package com.forge.fex.verilogprime.runner;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.beust.jcommander.IStringConverter;
import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.ParameterException;
import com.forge.common.FileUtils;
import com.forge.common.Utils;

import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.encoder.PatternLayoutEncoder;
import ch.qos.logback.classic.filter.ThresholdFilter;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.FileAppender;
import lombok.Data;
import lombok.Getter;

@Data
public class CommandLineParser {
	private static final Logger L = LoggerFactory.getLogger(CommandLineParser.class);
	@Parameter()
	private List<String> parameters;

	@Parameter(names = { "-o" }, description = "Output Directory", converter = FileNameConverter.class, required = true)
	File OutputDir;

	@Parameter(names = { "-f", "-F" }, description = "lib search path")
	private List<String> fOptionFiles;

	@Parameter(names = {
			"-fs" }, description = "path to Forge File", converter = FileNameConverter.class, required = true)
	private File forge;

	@Parameter(names = { "-t" }, description = "Top Module")
	private String t;

	@Parameter(names = { "-tot" }, description = "Top of the tree")
	private String tot;

	@Parameter(names = { "-ll" }, description = "Log level")
	private String ll;

	@Parameter(names = { "-lf" }, description = "Log file")
	private String lf;

	@Parameter(names = "-help", help = true, description = "Produces this Output")
	private boolean help;

	@Parameter(names = "-emitjson", description = "Emits json object for every template")
	private boolean emitjson;

	@Parameter(names = "-st", description = "Path to String template Directory")
	private File st;

	@Parameter(names = "-lec", description = "Emits lec scripts")
	private boolean lec;
	
	@Parameter(names = "-master", description = "Master auto stitching")
	private boolean stitchMaster;

	public File getOutputDir() {
		if (OutputDir.isDirectory()) {
			return OutputDir;
		} else {
			if (!OutputDir.mkdirs()) {
				throw new RuntimeException("Couldnt create output Directory");
			}
			return OutputDir;
		}
	}

	public File getSt() {
		return st;
	}

	@Getter
	public static List<File> inputFilesInOrder = new ArrayList<>();

	public List<String> getExtensions() {
		return Utils.arrList(".v", ".xv");
	}

	public static class FileNameConverter implements IStringConverter<File> {
		@Override
		public File convert(String value) {
			return new File(value);
		}

	}

	public final Integer MAX_FILES_COUNT = 1000;
	@Getter
	private Path sourceFile;
	private Path basePath;
	private List<CommandLineParser> children;
	private static Map<String, Path> includedVFilesMap = new HashMap<>();
	private static Map<String, Path> fOptionFilesMap = new HashMap<>();

	private boolean CompletedprocessingAllFOptionFiles;

	public CommandLineParser(String path) throws InvalidOptionException {
		children = new ArrayList<>();
		sourceFile = FileSystems.getDefault().getPath(path).normalize();
		if (!sourceFile.toFile().exists()) {
			throw new InvalidOptionException(basePath.toString());
		}
		if (sourceFile.toFile().isDirectory()) {
			basePath = sourceFile;
			sourceFile = null;
		} else {
			basePath = sourceFile.getParent();
		}
		parameters = new ArrayList<>();
		fOptionFiles = new ArrayList<>();
	}

	private Path getNormalizedPath(String path) {
		String topOfTree = getTot();
		if (topOfTree != null) {
			Path TOT = Paths.get(topOfTree).normalize();
			if (path.contains("$(TOT)")) {
				return TOT.resolve(path.replace("$(TOT)", topOfTree));
			}
		}
		return basePath.resolve(path).normalize();
	}

	private boolean isFile(Path normalizedPath, String extention) throws InvalidOptionException {
		if (normalizedPath.toFile().exists()) {
			return normalizedPath.toFile().isFile()
					&& FileUtils.getExtension(normalizedPath.toString()).toLowerCase().equals(extention);
		} else {
			throw new InvalidOptionException("File not found\t" + normalizedPath.toString());
		}
	}

	private boolean isVFile(Path normalizedPath) throws InvalidOptionException {
		return isFile(normalizedPath, "v");
	}

	private boolean isXVFile(Path normalizedPath) {
		return isFile(normalizedPath, "xv");
	}

	private boolean isFSFile(Path normalizedPath) {
		return isFile(normalizedPath, "fs");
	}

	private void processParametersForIncludedFiles() {
		List<String> removedEntries = new ArrayList<>();
		for (String param : parameters) {
			Path normalizedPath = getNormalizedPath(param);
			CommandLineParser.inputFilesInOrder.add(normalizedPath.toFile());
			if (isVFile(normalizedPath) || isXVFile(normalizedPath)) {
				removedEntries.add(param);
				CommandLineParser.includedVFilesMap.put(normalizedPath.toString(), normalizedPath);
			}
		}
		for (String param : removedEntries) {
			parameters.remove(param);
		}
	}

	private void processIncludeFiles() throws FileNotFoundException {
		if (!CompletedprocessingAllFOptionFiles) {
			processFsFile();
			processParametersForIncludedFiles();
			processFOptionFiles(new HashMap<String, Path>());
			CompletedprocessingAllFOptionFiles = true;
		}
	}

	private void processFsFile() {
		isFSFile(forge.toPath());
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("parameters=\n");
		for (String param : parameters) {
			sb.append("\t" + param + "\n");
		}
		sb.append("libPathList=\n");
		for (String file : fOptionFiles) {
			sb.append("\t" + file + "\n");
		}
		sb.append(CommandLineParser.fOptionFilesMap + "\n");
		return sb.toString();

	}

	public static void main(String[] args) {
		CommandLineParser clp = new CommandLineParser(new File("./").getAbsolutePath());
		try {
			CommandLineParser.L.info(System.setProperty(JCommander.DEBUG_PROPERTY, "debug"));
			JCommander jCommander = new JCommander(clp);
			jCommander.parse(args);
			CommandLineParser.L.info("Command=" + jCommander.getParsedCommand());
		} catch (ParameterException ex) {
			System.out.println(ex.getMessage());
		}
		System.out.println(clp);
		try {
			clp.processIncludeFiles();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(clp);
	}

	private void processFOptionFiles(Map<String, Path> processedFiles)
			throws FileNotFoundException, InvalidOptionException {
		if (fOptionFiles.size() > 0) {
			for (String file : fOptionFiles) {
				Path normalizedPath = getNormalizedPath(file);
				if (normalizedPath.toFile().exists() && !processedFiles.containsKey(normalizedPath.toString())) {
					CommandLineParser localCLP = new CommandLineParser(normalizedPath.toString());
					List<String> args = new ArrayList<>();
					args.add("-o");
					args.add(getOutputDir().getAbsolutePath());
					args.add("-t");
					args.add(getT());
					args.add("-fs");
					args.add(getForge().toString());
					if (getTot() != null) {
						args.add("-tot");
						args.add(getTot());
					}
					args.addAll(Arrays.asList(Stringify(normalizedPath.toFile())));
					new JCommander(localCLP, args.toArray(new String[1]));
					processedFiles.put(normalizedPath.toString(), normalizedPath);
					localCLP.processFOptionFiles(processedFiles);
					localCLP.processParametersForIncludedFiles();
					localCLP.CompletedprocessingAllFOptionFiles = true;
				}
			}
		}
	}

	private String[] Stringify(File file) throws FileNotFoundException, InvalidOptionException {
		if (file.exists() && file.isFile()) {
			String content = FileUtils.ReadFromFile(new FileInputStream(file));
			return content.split("\\s");
		} else {
			throw new InvalidOptionException(file.getAbsolutePath());
		}
	}

	public List<Path> getIncludedFiles() {
		ArrayList<Path> includedFiles = new ArrayList<>();
		for (Entry<String, Path> entry : CommandLineParser.includedVFilesMap.entrySet()) {
			includedFiles.add(entry.getValue());
		}
		return includedFiles;
	}

	public void processArgs() throws FileNotFoundException {
		clearOutputDirectory();
		processLogInfo();
		processStringTemplateDir();
		processIncludeFiles();
	}

	private void processStringTemplateDir() {
		if (st != null) {
			if (!st.exists()) {
				throw new RuntimeException("String template directory does not exist");
			}
			if (!st.isDirectory()) {
				throw new RuntimeException("The path given as String template is not a Directory");
			}
			if (t == null) {
				throw new RuntimeException("please provide -t option");
			}
		} else {
			if (!emitjson) {
				throw new RuntimeException("-st and -emitjson options both missing. Please specify any one");
			}
		}
	}

	private void clearOutputDirectory() {
		File output = getOutputDir();
		if (output != null) {
			if (!output.exists()) {
				output.mkdir();
			} else {
				CommandLineParser.L.info("Clearing files in output directory" + output.getAbsolutePath());
				List<File> files = FileUtils.allFilesInDir(output.toString());
				for (File f : files) {
					FileUtils.Delete(f, true);
				}
			}
		}
	}

	private void processLogInfo() {
		if (ll != null) {
			if (!(ll.equals("debug") || ll.equals("info") || ll.equals("warn") || ll.equals("error")
					|| ll.equals("DEBUG") || ll.equals("INFO") || ll.equals("WARN") || ll.equals("ERROR"))) {
				try {
					throw new Exception("Log levels can be debug | info | warn | error");
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				Utils.setRootLogLevel(ll);
			}
		}
		String fileName = null;
		if (lf != null) {
			File f = new File(lf);
			if (f.exists()) {
				f.delete();
			}
			try {
				f.createNewFile();
				f.delete();
				fileName = lf;
			} catch (IOException e) {
				throw new RuntimeException("Cannot create outfile. Please check -LF parameter");
			}
		} else {
			// fileName = getOutputDir().getAbsolutePath()+"/forge.log";
			fileName = getOutputDir() + "/forge.log";
			File f = new File(fileName);
			if (f.exists()) {
				f.delete();
			}
			try {
				f.createNewFile();
				f.delete();
			} catch (IOException e) {
				throw new RuntimeException("Cannot create outfile forge.log at -o");
			}
		}
		LoggerContext context = (LoggerContext) LoggerFactory.getILoggerFactory();

		FileAppender<ILoggingEvent> file = new FileAppender<>();
		file.setName("FileLogger");
		file.setFile(fileName);
		file.setContext(context);
		file.setAppend(true);

		ThresholdFilter warningFilter = new ThresholdFilter();
		if(ll == null){
			warningFilter.setLevel("WARN");
		} else {
			warningFilter.setLevel(ll.toUpperCase());
		}
		warningFilter.setContext(context);
		warningFilter.start();
		file.addFilter(warningFilter);

		PatternLayoutEncoder ple = new PatternLayoutEncoder();
		ple.setContext(context);
		ple.setPattern("[%d{yyyy-MM-dd HH:mm:ss}] [%r] [%thread] %-5level %-20logger{1} - %msg%n");
		ple.start();
		file.setEncoder(ple);

		file.start();

		ch.qos.logback.classic.Logger chl = (ch.qos.logback.classic.Logger) Utils.getRootLogger();
		chl.addAppender(file);
	}

}
