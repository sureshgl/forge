package com.forge.runner;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stringtemplate.v4.ST;
import com.forge.common.FileUtils;
import com.forge.fex.verilogprime.utils.MemogenErrorException;
import com.forge.parser.ForgeUtils;
import com.forge.parser.ParentLastURLClassLoader;
import com.forge.parser.ProcessUtil;
import com.forge.parser.ProcessUtil.ProcessGroup;
import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.data.HashTable;
import com.forge.parser.data.HtmlForStg;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.MemogenCut;
import com.forge.parser.data.Memory;
import com.forge.parser.data.MemoryForStg;
import com.forge.parser.data.MemoryWrapForStg;
import com.forge.parser.data.Register;
import com.forge.parser.data.RnaxiMemWrapForStg;
import com.forge.parser.data.RnaxiRegWrapForStg;
import com.forge.parser.data.RnaxiSlvAddrDecoderForStg;
import com.forge.parser.data.RnaxiSlvTopForStg;
import com.forge.parser.gen.ForgeParser.StartContext;

import lombok.Data;

@Data
public class ForgeRunnerSession {
	private static final Logger L = LoggerFactory.getLogger(ForgeRunnerSession.class);

	private File output;
	private String forgeSpec;
	private boolean emitjson;
	private Map<String,String> topModuleParameters;

	public ForgeRunnerSession(File output, String forgeSpec, boolean emitjson, File st, Map<String, String> topModuleParameters) {
		this.output = output;
		this.forgeSpec = forgeSpec;
		this.emitjson = emitjson;
		this.topModuleParameters = topModuleParameters;
		ForgeUtils.setSt(st);
	}

	private void validateAllForgeSpecFiles() {
		boolean hasParseError = false;
		FileParser fp = new FileParser();
		File forgeSpecFile = new File(forgeSpec);
		fp.getFileContent(forgeSpecFile);
		hasParseError |= FileParser.hasForgeError;
		if (hasParseError) {
			throw new IllegalStateException("One or more Forge spec cannot be parsed properly");
		}
	}

	private void semanticChecks(StartContext startContext) {
		SemanticChecks semanticChecks = new SemanticChecks();
		semanticChecks.run(startContext);
	}

	public void run() {
		validateAllForgeSpecFiles();
		FileParser fp = new FileParser();
		File forgeSpecFile = new File(forgeSpec);
		StartContext sc = fp.getFileContent(forgeSpecFile);
		sc.extendedContext.resolveParameters(topModuleParameters);
		semanticChecks(sc);
		AtomicInteger offset = new AtomicInteger();
		sc.extendedContext.calculateOffset(offset);
		generateVerilogFiles(sc);
		sc.extendedContext.getverilogHeader(this);
	}

	private void generateVerilogFiles(StartContext sc) {
		List<Memory> memories = ForgeUtils.getMemories(sc);
		List<Register> registers = ForgeUtils.getRegisters(sc);
		List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
		List<IMemogenCut> memogenCuts = ForgeUtils.getMemogenCuts(sc);
		if(memogenCuts.size() >0){
			emitMemogenCuts(memogenCuts);
		}
		if(memories.size() >0 || registers.size() >0 || hashtables.size() >0){
			boolean emitFile = true;
			if (emitjson && ForgeUtils.getSt() == null) {
				emitFile = false;
			}
			try {
				emitMemories(memories, emitFile);
			} catch (MemogenErrorException e) {
				L.warn("Memogen Memory not generated.");
			}
			emitRnaxiRegWrap(registers, emitFile);
			emitRnaxiMemWrap(memories, emitFile);
			emitHtml(memories, registers, emitFile);
			emitRnaxiSlvAddrDecoder(memories, registers, emitFile);
			emitRnaxiSlvtop(memories, registers, emitFile,hashtables);
			if (!emitFile) {
				ForgeRunnerSession.L.info("Jsons are emitted");
				System.exit(0);
			}
		} else {
			ForgeUtils.setShouldStitch(false);
		}
	}

	public void emitMemogenCuts(List<IMemogenCut> memogenCuts){
		for(IMemogenCut cut : memogenCuts){
			MemogenCut memogenCut = new MemogenCut(cut,output);
			if(memogenCut.getAlgo() != null){
				try {
					generateMemogenMem(memogenCut);
				} catch ( NoSuchMethodException| SecurityException | 
						ClassNotFoundException | MalformedURLException e) {
					e.printStackTrace();
				}
			} else {
				L.info("PortCap "+cut.getPortCap().trim() +" not supported yet, skipping memogen");
			}
		}
	}

	public void emitHtml(List<Memory> memories, List<Register> registers, boolean emitFile) {
		HtmlForStg htmlForStg = new HtmlForStg(ForgeUtils.getForgeSpecName(), registers,memories);
		if (emitFile){
			ST template = ForgeUtils.getHtmlStringTemplate();
			template.add("htmlForStg", htmlForStg);
			writeFile(ForgeUtils.getForgeSpecName() + ".html", template.render());
		}
	}

	public void emitMemories(List<Memory> memories, boolean emitFile) throws MemogenErrorException{
		if(memories.size() > 0){
			for (Memory memory : memories) {
				MemInstance instanceForMemogen = memory.getInstances().get(0);
				MemogenCut cut = new MemogenCut(instanceForMemogen,output);
				if(instanceForMemogen.getMemogenCmdLine() != null){	
					if(cut.getAlgo() != null){
						try {
							generateMemogenMem(cut);
						} catch ( NoSuchMethodException| SecurityException | 
								ClassNotFoundException | MalformedURLException e) {
							e.printStackTrace();
						}
					} else {
						L.info("PortCap "+instanceForMemogen.getPortCap().trim() +" not supported yet, skipping memogen");
					}
				}
				for (MemInstance memInstance : memory.getInstances()) {
					MemoryWrapForStg memoryWrapForStg = new MemoryWrapForStg(memInstance);
					if (emitFile) {
						ST template = ForgeUtils.getMemoryWrapStringTemplate();
						template.add("memoryWrapForStg", memoryWrapForStg);
						writeFile(ForgeUtils.getForgeSpecName() + "_" + memInstance.getName() + "_mem_wrap.xv", template.render());
					}
					if (emitjson) {
						// write mem wrap json
					}
					if (!memInstance.getIsInterfaceOnly()) {
						MemoryForStg memoryForStg = new MemoryForStg(memInstance);
						if (emitFile) {
							ST template = ForgeUtils.getMemoryWithoutMemogenStringTemplate();
							if(instanceForMemogen.getMemogenCmdLine() != null){	
								if(cut.getAlgo() != null){
									template = ForgeUtils.getMemoryStringTemplate();
								}
							}
							template.add("memoryForStg", memoryForStg);
							writeFile(ForgeUtils.getForgeSpecName() + "_" + memInstance.getName() + "_mem.xv", template.render());
						}
						if (emitjson) {
							// write mem json
						}
					}
				}
			}
		}
	}

	public void generateMemogenMem(MemogenCut cut) throws  MalformedURLException, ClassNotFoundException, NoSuchMethodException, SecurityException {
		URL[] urls = null;
		try {
			// Convert the file object to a URL
			String path = ForgeRunnerSession.class.getProtectionDomain().getCodeSource().getLocation().getPath();
			path = URLDecoder.decode(path, "UTF-8");
			String parent= new File(new File(path).getParentFile().getPath()).getPath();
			URL url = new File(parent+"/memogen_package/jar/dist/memogen-3.3.10338M-fat.jar").toURI().toURL();
			urls = new URL[]{url};
		} catch (MalformedURLException | UnsupportedEncodingException e) {
		}
		ParentLastURLClassLoader cl = new ParentLastURLClassLoader(Arrays.asList(urls),Thread.currentThread().getContextClassLoader());
		Class<?> clas = cl.loadClass("com.memoir.memogen.run.MemogenCmdLineRunner");
		Class<?> mainArgType[] = { (new String[0]).getClass() };
		Method main = clas.getMethod("main", mainArgType);
		Object argsArray[] = { cut.getOptionsAsArray() };
		try{
			main.invoke(null, argsArray);
		}
		catch(Throwable ex){
			System.out.println(Thread.currentThread().getContextClassLoader().getClass().getName());
		}
		unroll(cut.getName());
	}

	private void unroll(String name) {
		List<String> cmd = new ArrayList<String>();
		cmd.add("./unroll.sh");
		cmd.add("-name");
		cmd.add(name);
		cmd.add("-nolec");
		cmd.add("-type");
		cmd.add("real,func");
		//		cmd.add("+vcs+lic+wait");
		File exeDir = new File(output+"/memogen/run_sample");
		ProcessGroup processGroup = ProcessUtil.executeProcessBlocking(cmd, exeDir.getAbsolutePath(), false);
		if((processGroup.getProcess().exitValue() != 0)){
			L.info(String.join(" ", cmd));
			throw new RuntimeException("Error in unrolling cut "+name);
		}
	}

	private void emitRnaxiRegWrap(List<Register> registers, boolean emitFile) {
		if (registers.size() > 0) {
			RnaxiRegWrapForStg rnaxiRegWrapForStg = new RnaxiRegWrapForStg(registers);
			if (emitFile) {
				ST template = ForgeUtils.getRnaxiRegWrapStringTemplate();
				template.add("rnaxiRegWrapForStg", rnaxiRegWrapForStg);
				writeFile(ForgeUtils.getForgeSpecName() + "_rnaxi_reg_wrap.xv", template.render());
			}
			if (emitjson) {
				writeJson(ForgeUtils.getForgeSpecName() + "_rnaxi_reg_wrap.json", rnaxiRegWrapForStg);
			}
		}
	}

	private void emitRnaxiMemWrap(List<Memory> memories, boolean emitFile) {
		if (memories.size() > 0) {
			RnaxiMemWrapForStg rnaxiMemWrapForStg = new RnaxiMemWrapForStg(memories);
			if (emitFile) {
				ST template = ForgeUtils.getRnaxiMemWrapStringTemplate();
				template.add("rnaxiMemWrapForStg", rnaxiMemWrapForStg);
				writeFile(ForgeUtils.getForgeSpecName() + "_rnaxi_mem_phy_wrap.xv", template.render());
			}
			if (emitjson) {
				writeJson(ForgeUtils.getForgeSpecName() + "_rnaxi_mem_phy_wrap.json", rnaxiMemWrapForStg);
			}
		}
	}

	private void emitRnaxiSlvAddrDecoder(List<Memory> memories, List<Register> registers, boolean emitFile) {
		RnaxiSlvAddrDecoderForStg rnaxiSlvAddrDecoderForStg = new RnaxiSlvAddrDecoderForStg(registers,memories);
		if (emitFile) {
			ST template = ForgeUtils.getRnaxiSlvAddrDecoderStringTemplate();
			template.add("rnaxiSlvAddrDecoderForStg", rnaxiSlvAddrDecoderForStg);
			writeFile(ForgeUtils.getForgeSpecName() + "_rnaxi_slv_addr_dec.xv", template.render());
		}
		if (emitjson) {
			writeJson(ForgeUtils.getForgeSpecName() + "_rnaxi_slv_addr_dec.json", rnaxiSlvAddrDecoderForStg);
		}
	}

	public void emitRnaxiSlvtop(List<Memory> memories, List<Register> registers, boolean emitFile,List<HashTable> hashtables) {
		RnaxiSlvTopForStg rnaxiSlvTopForStg = new RnaxiSlvTopForStg(memories, registers.size() > 0,hashtables);
		if (emitFile) {
			ST template = ForgeUtils.getRnaxiSlvTopStringTemplate();
			template.add("rnaxiSlvTopForStg", rnaxiSlvTopForStg);
			writeFile(ForgeUtils.getForgeSpecName() + "_rnaxi_slv_top.xv", template.render());
		}
		if (emitjson) {
			writeJson(ForgeUtils.getForgeSpecName() + "_rnaxi_slv_top.json", rnaxiSlvTopForStg);
		}
	}

	private void writeFile(String filename, String render) {
		File file = new File(getOutput().toString() + "/" + filename);
		if (file.exists()) {
			file.delete();
		}
		try {
			file.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Could not create file " + file.toString());
		}
		FileUtils.writeToFile(file, false, render);
	}

	public void emitJsonTest(StartContext sc) {
		if (emitjson) {
			List<Memory> memories = ForgeUtils.getMemories(sc);
			List<Register> registers = ForgeUtils.getRegisters(sc);
			List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
			RnaxiRegWrapForStg rnaxiRegWrapForStg = new RnaxiRegWrapForStg(registers);
			writeJson("rnaxi_reg_wrap.json", rnaxiRegWrapForStg);

			RnaxiMemWrapForStg rnaxiMemWrapForStg = new RnaxiMemWrapForStg(memories);
			writeJson("rnaxi_mem_wrap.json", rnaxiMemWrapForStg);

			RnaxiSlvAddrDecoderForStg rnaxiSlvAddrDecoderForStg = new RnaxiSlvAddrDecoderForStg(registers, memories);
			writeJson("rnaxi_slv_addr_decoder.json", rnaxiSlvAddrDecoderForStg);

			RnaxiSlvTopForStg rnaxiSlvTopForStg = new RnaxiSlvTopForStg(memories, registers.size() > 0,hashtables);
			writeJson("rnaxi_slv_top.json", rnaxiSlvTopForStg);
		}
	}

	private void writeJson(String string, Object obj) {
		File file = new File(getOutput().toString() + "/" + string);
		if (file.exists()) {
			file.delete();
		}
		try {
			file.createNewFile();
		} catch (IOException e) {
			throw new RuntimeException("Could not create file " + file.toString());
		}
		ObjectMapper mapper = new ObjectMapper();
		try {
			mapper.defaultPrettyPrintingWriter().writeValue(file, obj);
		} catch (IOException e) {
			throw new RuntimeException("Could not write Object to " + file);
		}
	}

	public List<String> getChain() {
		FileParser fp = new FileParser();
		File forgeSpecFile = new File(forgeSpec);
		StartContext sc = fp.getFileContent(forgeSpecFile);
		List<String> chain = new ArrayList<String>();
		sc.extendedContext.collectModulesToStitchForTop(chain);
		return chain;
	}
}
