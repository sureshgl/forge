package com.forge.fex.verilogprime.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_identifierContext;

import lombok.Data;

@Data
public class ModuleIndexer {
	@Data
	public static class ModuleEntry {
		private final File file;
		private final String moduleName;
		private final int startLine;
		private int endLine;
		private List<Module_identifierContext> module_instantiations;
		private Boolean processed = false;

		@Override
		public String toString() {
			return file + ", moduleName=" + moduleName + ", startLine=" + startLine + ", endLine=" + endLine;
		}
	}

	private static final Logger L = LoggerFactory.getLogger(ModuleIndexer.class);
	private final List<Path> files;
	private final Map<String, ModuleEntry> index = new LinkedHashMap<>();

	public ModuleIndexer(List<Path> paths) {
		this.files = paths;
		try {
			index(paths);
		} catch (IOException e) {
			ModuleIndexer.L.error("Error indexing files");
			throw new RuntimeException();
		}
	}

	public void collectModuleNames() {
		for (String module_name : index.keySet()) {
			Module_declarationContext module_declarationContext = SingletonModuleUtility.getInstance()
					.getModule(module_name);
			if (index.get(module_name).module_instantiations == null) {
				index.get(module_name).module_instantiations = new ArrayList<>();
			}
			index.get(module_name).module_instantiations = module_declarationContext.extendedContext
					.getModuleInstantiations();
		}
	}

	public void collectModuleNames(String module_name) {
		Module_declarationContext module_declarationContext = SingletonModuleUtility.getInstance()
				.getModule(module_name);
		if (index.get(module_name).module_instantiations == null) {
			index.get(module_name).module_instantiations = new ArrayList<>();
		}
		index.get(module_name).module_instantiations = module_declarationContext.extendedContext
				.getModuleInstantiations();
	}

	public void reIndex(Path path) throws IOException {
		List<Path> paths = new ArrayList<>();
		paths.add(path);
		index(paths);
	}

	public void index(List<Path> paths) throws IOException {
		Pattern patternStart = Pattern.compile("\\s*(\\bmodule\\b|\\bmacromodule\\b)\\s+(\\w+).*");
		Pattern patternend = Pattern.compile("\\s*endmodule\\s*.*");
		for (Path path : paths) {
			BufferedReader br = new BufferedReader(new FileReader(path.toFile()));
			String line;
			int count = 0;
			Stack<ModuleEntry> stack = new Stack<>();
			while ((line = br.readLine()) != null) {
				Matcher m = patternStart.matcher(line);
				if (m.matches()) {
					String modName = m.group(2);
					ModuleIndexer.L.debug("Dectected Module :" + modName + " at " + count);
					if (index.containsKey(modName)) {
						ModuleIndexer.L.info("Duplicate Module " + modName + " Description exists");
						ModuleIndexer.L.info("reindexing");
					}
					// br.close();
					// throw new RuntimeException("Duplicate Module "+modName+" Description exists
					// in files:"+
					// path.toFile().getAbsolutePath()+" and
					// "+index.get(modName).getFile().getAbsolutePath());
					// }else{
					stack.push(new ModuleEntry(path.toFile(), modName, count));
					// }
				}
				Matcher m2 = patternend.matcher(line);
				if (m2.matches()) {
					ModuleEntry me = stack.pop();
					me.setEndLine(count);
					index.put(me.getModuleName(), me);
				}
				count++;
			}
			br.close();
			if (stack.size() != 0) {
				throw new RuntimeException("Error Occured During Indexing. Weak Kung-Fu");
			}
		}
	}

	public Set<String> getModuleNames() {
		return index.keySet();
	}

	public ModuleEntry getEntryForModule(String moduleName) {
		return index.get(moduleName);
	}

	public boolean containsModule(String moduleName) {
		return index.containsKey(moduleName);
	}

	public Boolean isProcessed(String module_name) {
		if (index.get(module_name) == null) {
			ModuleIndexer.L.error("Missing module at Indexer - " + module_name);
		}
		if (index.get(module_name).processed != null && index.get(module_name).processed) {
			return true;
		} else {
			return false;
		}
	}

	public Boolean canProcess(String module_name) {
		for (Module_identifierContext module_identifierContext : index.get(module_name).module_instantiations) {
			if (!isProcessed(module_identifierContext.extendedContext.getModuleName())) {
				return false;
			}
		}
		return true;
	}

	public Path getFilePath(String module_name) {
		for (Path file : files) {
			String fname = file.toFile().getName();
			int pos = fname.lastIndexOf(".");
			if (pos > 0) {
				fname = fname.substring(0, pos);
			}
			if (fname.equals(module_name)) {
				return file;
			}
		}
		return null;
	}
}
