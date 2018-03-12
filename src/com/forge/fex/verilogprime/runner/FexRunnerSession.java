package com.forge.fex.verilogprime.runner;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;
import org.stringtemplate.v4.StringRenderer;

import com.forge.common.FileUtils;
import com.forge.fex.verilogprime.ext.AbstractBaseExt;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_identifierContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Source_textContext;
import com.forge.fex.verilogprime.utils.ExtendedContextVisitor;
import com.forge.fex.verilogprime.utils.ModuleIndexer;
import com.forge.fex.verilogprime.utils.SingletonModuleUtility;
import com.forge.parser.ForgeUtils;
import com.forge.parser.ProcessUtil;
import com.forge.parser.ProcessUtil.ProcessGroup;
import com.forge.runner.ForgeRunnerSession;

import lombok.Data;

@Data
public class FexRunnerSession {
	private static final Logger L = LoggerFactory.getLogger(FexRunnerSession.class);

	private final CommandLineParser clp;
	private ForgeRunnerSession forgeSession;
	private ModuleIndexer mi = null;
	private ModuleParser mp;
	List<String> wrapperModules = null;
	private SingletonModuleUtility singletonModuleUtility = SingletonModuleUtility.getInstance();
	List<String> modulesToStitch = new ArrayList<>();
	private List<String> genXVFilePaths = new ArrayList<>();
	private List<String> genLibFilePaths = new ArrayList<>();

	public FexRunnerSession(CommandLineParser cp) {
		this.clp = cp;
	}

	public void setForgeSession(ForgeRunnerSession forgeSession){
		this.forgeSession = forgeSession;
	}

	private void index() {
		List<Path> allFiles = clp.getIncludedFiles();
		mi = new ModuleIndexer(allFiles);
		mp = new ModuleParser(mi);
	}

	private AbstractBaseExt getExtendedContext(ParseTree ctx) {
		if (ctx != null) {
			return new ExtendedContextVisitor().visit(ctx);
		}
		return null;
	}

	public void run() {
		FexRunnerSession.L.info("Running Fex runner");
		modulesToStitch = processGeneratedFiles();
		if(ForgeUtils.isShouldStitch()){
			collectModules();
			mi.collectModuleNames();
			List<String> allModuleNames = new ArrayList<>(mi.getModuleNames());
			stitchGeneratedFiles(modulesToStitch);
			for (String module_name : allModuleNames) {
				process(module_name);
			}
			emitLecScripts();
		}
		emitRTLFile();
	}

	public void init(){
		index();
		collectModules();
	}

	public Map<String, String> collectTopModuleParameters() {
		init();
		ParserRuleContext parserRuleContext = SingletonModuleUtility.getInstance().getModule(clp.getT());
		AbstractBaseExt extendedContext = getExtendedContext(parserRuleContext);
		Map<String,ParserRuleContext> parameterMap = new LinkedHashMap<String,ParserRuleContext>();
		extendedContext.populateParametersForForgeEvaluation(parameterMap);
		return ForgeUtils.evaluateParameters(parameterMap);
	}

	public void emitLecScripts() {
		if (clp.isLec()) {
			FileUtils.Copy(FexRunnerSession.class.getResourceAsStream("/lec/lec.dofile"),
					new File(clp.OutputDir + "/lec.dofile"));
			STGroupFile grp = new STGroupFile("lec/lec_dc.stg");
			grp.registerRenderer(String.class, new StringRenderer());

			ST lecTemplate = grp.getInstanceOf("LecDCScript");
			String goldenTop = null;
			String revisedFiles = new String();
			String revisedTop = null;
			String topModuleName = clp.getT();
			String goldenFiles = new String();
			for (Path file : mi.getFiles()) {
				if (file.getFileName().endsWith(topModuleName + ".v")) {
					goldenTop = file.toAbsolutePath().toString();
				} else {
					goldenFiles = goldenFiles + " " + file;
				}
			}

			for (String fileName : modulesToStitch) {
				if (fileName.equals(topModuleName)) {
					if (new File(clp.getOutputDir().getAbsolutePath() + "/" + fileName + ".xv").exists()) {
						revisedTop = clp.getOutputDir().getAbsolutePath() + "/" + fileName + ".xv";
					}
				} else if (new File(clp.getOutputDir().getAbsolutePath() + "/" + fileName + ".xv").exists()) {
					revisedFiles = revisedFiles + " " + clp.getOutputDir().getAbsolutePath() + "/" + fileName + ".xv";
				}
			}
			revisedFiles = goldenFiles + " " + revisedFiles;

			lecTemplate.add("goldenTop", goldenTop);
			lecTemplate.add("revisedTop", revisedTop);
			lecTemplate.add("readGolden", goldenFiles);
			lecTemplate.add("readRevised", revisedFiles);
			FileUtils.WriteFile(new File(clp.OutputDir + "/lec_dc.sh"), lecTemplate.render());
		}
	}

	public void stitchGeneratedFiles(List<String> modulesToStitch) {
		Map<String, Boolean> filesToStitch = new HashMap<>();
		for (String module_name : modulesToStitch) {
			if(!module_name.contains("_ram_"))
				filesToStitch.put(module_name, false);
		}
		while (!stitchingComplete(filesToStitch)) {
			for (String module_name : filesToStitch.keySet()) {
				if (filesToStitch.get(module_name) == false) {
					ParserRuleContext parserRuleContext = SingletonModuleUtility.getInstance().getModule(module_name);
					AbstractBaseExt extendedContext = getExtendedContext(parserRuleContext);
					List<Module_identifierContext> instantiations = extendedContext.getModuleInstantiations();
					Boolean shouldProcess = true;
					for (Module_identifierContext module_identifierContext : instantiations) {
						String intantiated_module_name = module_identifierContext.extendedContext.getFormattedText();
						if (filesToStitch.containsKey(intantiated_module_name)) {
							shouldProcess &= filesToStitch.get(intantiated_module_name);
						}
					}
					if (shouldProcess) {
						stitch(module_name);
						filesToStitch.put(module_name, true);
					}
				}
			}
		}
	}

	private boolean stitchingComplete(Map<String, Boolean> filesToStitch) {
		Boolean ret = true;
		for (String module_name : filesToStitch.keySet()) {
			ret &= filesToStitch.get(module_name);
		}
		return ret;
	}

	private void stitch(String module_name) {
		ParserRuleContext parserRuleContext = SingletonModuleUtility.getInstance().getModule(module_name);
		AbstractBaseExt extendedContext = getExtendedContext(parserRuleContext);
		Map<String, ParserRuleContext> addedLogics = new LinkedHashMap<>();
		Map<String, Net_declarationContext> addedWires = new LinkedHashMap<>();
		Map<String, String> addedParameters = new LinkedHashMap<>();
		if (module_name.equals(clp.getT())) {
			extendedContext.stitchOnlySlvTop(module_name, addedParameters, addedLogics, addedWires);
		} else {
			extendedContext.stitch(module_name, addedParameters, addedLogics, addedWires);
		}
		String wrapperString = extendedContext.getWrapperString(extendedContext, addedLogics, addedWires,
				addedParameters, new HashMap<String, String>());
		writeFile(module_name, wrapperString);
	}

	private void emitInputRTL() {
		if (clp.getFOptionFiles().size() > 0) {
			for (String file : clp.getFOptionFiles()) {
				for (String path : FileUtils.ReadLines(new File(file))) {
					if (!path.endsWith("/" + ForgeUtils.getForgeSpecName() + ".v")
							&& !path.equals(ForgeUtils.getForgeSpecName() + ".v")) {
						if (path.contains("$(TOT)")) {
							path = path.replace("$(TOT)", clp.getTot());
						}
						FileUtils.AppendToFile(new File(
								clp.getOutputDir() + File.separator + "rtl_" + ForgeUtils.getForgeSpecName() + ".f"),
								path + "\n");
					}
				}
			}
		}
  }

  private void emitGenRTL() {
    for (String path : genXVFilePaths) {
      FileUtils.AppendToFile(
          new File(clp.getOutputDir() + File.separator + "rtl_" + ForgeUtils.getForgeSpecName() + ".xf"),
          path + "\n");
    }
    File rltLibs = new File(clp.getOutputDir() + File.separator + "rtl_libs.xf");
    if(rltLibs.exists())
      FileUtils.Delete(rltLibs, true);
    FileUtils.CreateNewFile(rltLibs);
    for(String path : genLibFilePaths){
      FileUtils.AppendToFile(
          new File(clp.getOutputDir() + File.separator + "rtl_libs.xf"),
          path + "\n");
    }
  }


	private void emitRTLFile() {
		// if(clp.getFOptionFiles().size() >0) {
		// for(String file :clp.getFOptionFiles()) {
		// File inputFile = new File(file);
		// rtlFilePaths.addAll(FileUtils.ReadLines(inputFile));
		// }
		// }
		// for(Path path: mi.getFiles()) {
		// rtlFilePaths.add(path.toString());
		// }
		// rtlFilePaths.removeIf((String path) ->
		// path.endsWith("/"+forgeSession.getForgeSpecName()+".v"));
		// for(String path : rtlFilePaths)
		// if(!path.equals(forgeSession.getForgeSpecName()+".v")) {
		// path = path.replace("$(TOT)", clp.getTot());
		// FileUtils.AppendToFile(new File(clp.getOutputDir()+File.separator
		// +"rtl_"+forgeSession.getForgeSpecName()+".f"), path+"\n");
		// }
		emitInputRTL();
		emitGenRTL();
	}

	private void writeFile(String wrapModuleName, String wrapperString) {
		File f = new File(clp.getOutputDir() + File.separator + wrapModuleName + ".xv");
		FileUtils.writeToFile(f, false, wrapperString);
		try {
			if (clp.getTot() != null) {
				genXVFilePaths.add(f.getCanonicalPath());
			} else {
				genXVFilePaths.add("." + File.separator + wrapModuleName + ".xv");
			}
			mi.index(Arrays.asList(f.toPath()));
		} catch (IOException e) {
			e.printStackTrace();
		}
		mi.collectModuleNames(wrapModuleName);
		Source_textContext ctx = mp.getModule(wrapModuleName);
		ctx.extendedContext.collectModules();
	}

	private String getName(File file) {
		String last = file.getName();
		return last.substring(0, last.lastIndexOf('.'));
	}

	private List<String> processGeneratedFiles() {
		if(ForgeUtils.isShouldStitch())
			writeXv(clp.getT());
		List<File> filesInOutDir = FileUtils.allFilesInDir(clp.getOutputDir().toString(), "xv");
		List<Path> paths = new ArrayList<>();
		List<String> moduleNames = new ArrayList<>();
		for (File file : filesInOutDir) {
			paths.add(file.toPath());
			moduleNames.add(getName(file));
		}
		List<File> memogenFiles = processMemogenFiles();
		for(File file : memogenFiles){
			paths.add(file.toPath());
			moduleNames.add(getName(file));
		}
		try {
			mi.index(paths);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return moduleNames;
	}

	private List<File> processMemogenFiles() {
		File memogenRtl = new File(clp.getOutputDir().toString()+"/memogen/rtl_unrolled");
		File simlibs = new File(clp.getOutputDir().toString()+"/memogen/run_sample/simlibs");
		List<File> files = FileUtils.allFilesInDir(clp.getOutputDir().toString()+"/memogen/run_sample");
		for(File f : files){
			if(f.getName().contains("_LIBS.f")){
				genLibFilePaths.add("-f "+ f.getAbsolutePath());
			}
		}
		if(simlibs.exists()){
			files = FileUtils.allFilesInDir(clp.getOutputDir().toString()+"/memogen/run_sample/simlibs", "v");
			for(File f : files){
				genLibFilePaths.add(f.getAbsolutePath());
			}
		}
		if(memogenRtl.exists()){
			files =  FileUtils.allFilesInDir(clp.getOutputDir().toString()+"/memogen/rtl_unrolled", "v");
			for(File f : files){
				try{
					if (clp.getTot() != null) {
						genXVFilePaths.add(f.getCanonicalPath());
					} else {
						genXVFilePaths.add("./memogen/rtl_unrolled" + File.separator + f.getName());
					}
				} catch(IOException e){
					e.printStackTrace();
				}
			}
			if(files != null && files.size() >0){
				File outForPreProcessedMemogen = new File(clp.getOutputDir().toString()+"/memogen_preprocessed");
				if(outForPreProcessedMemogen.exists())
					FileUtils.Delete(outForPreProcessedMemogen, true);
				outForPreProcessedMemogen.mkdirs();
				preprocess(outForPreProcessedMemogen,files);
			}
			List<File> preprocessedFiles =  FileUtils.allFilesInDir(clp.getOutputDir().toString()+"/memogen_preprocessed", "v");
			return preprocessedFiles;
		} else {
			return new ArrayList<File>();
		}
	}
	private void preprocess(File outForPreProcessedMemogen, List<File> files) {
		List<String> cmd = new ArrayList<String>();
		String path = FexRunnerSession.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		try {
			path = URLDecoder.decode(path, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String parent= new File(new File(path).getParentFile().getPath()).getPath();
		cmd.add("java");cmd.add("-cp");cmd.add(parent+"/preprocessor/proteus_preprocess-3.3.9725-fat.jar");
		cmd.add("com.memoir.preprocess.runner.PreprocessRunner");
		cmd.add("-o ");cmd.add(outForPreProcessedMemogen.toString());
		for(File f : files){
			cmd.add(f.toString());
		}
		File forgeDir = new File("");
		ProcessGroup processGroup = ProcessUtil.executeProcessBlocking(cmd, forgeDir.getAbsolutePath(), false);
		String err = processGroup.getStderrReader().getOutput();
		if((processGroup.getProcess().exitValue() != 0) || (err != null && !err.equals(""))){
			L.info("Error in preprocessing of file "+files.toString());
			L.info(String.join(" ", cmd));
			System.exit(1);
		}
	}

	private Path writeXv(String module_name) {
		Source_textContext topContext = mp.getModule(module_name);
		String content = topContext.extendedContext.getFormattedText();
		String instantiation = ForgeUtils.getForgeSpecName() + "_rnaxi_slv_top  u_" + ForgeUtils.getForgeSpecName()
		+ "_rnaxi_slv_top ();\nendmodule";
		content = content.replace("endmodule", instantiation);
		File xv = new File(clp.getOutputDir() + "/" + module_name + ".xv");
		FileUtils.writeToFile(xv, false, content);
		return xv.toPath();
	}

	private void collectModules() {
		for(String module_name : mi.getModuleNames()){
			Source_textContext source_textContext = mp.getModule(module_name);
			source_textContext.extendedContext.collectModules();
		}
	}

	private void process(String module_name) {
		ParserRuleContext parserRuleContext = SingletonModuleUtility.getInstance().getModule(module_name);
		AbstractBaseExt extendedContext = getExtendedContext(parserRuleContext);
		extendedContext.checkConnections(module_name);
	}

	public void stitchMaster(List<String> chain) {
		init();
		ParserRuleContext parserRuleContext = SingletonModuleUtility.getInstance().getModule(clp.getT());
		AbstractBaseExt extendedContext = getExtendedContext(parserRuleContext);
		extendedContext.appendRnaxiPorts(chain);
		Map<String, ParserRuleContext> addedLogics = new LinkedHashMap<>();
		Map<String, Net_declarationContext> addedWires = new LinkedHashMap<>();
		Map<String, String> addedParameters = new LinkedHashMap<>();
		extendedContext.stitchOnly(chain,clp.getT(), addedParameters, addedLogics, addedWires);
		writeFile(clp.getT(), extendedContext.getFormattedText());
	}
}
