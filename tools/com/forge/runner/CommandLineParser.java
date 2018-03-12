package com.forge.runner;

import java.io.File;
import java.io.FileNotFoundException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.beust.jcommander.IStringConverter;
import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.ParameterException;
import com.forge.common.FileUtils;

import lombok.Data;
import lombok.Getter;

@Data
public class CommandLineParser {
	private static final Logger L = LoggerFactory.getLogger(CommandLineParser.class);
	@Parameter()
	private List<String> parameters;

	@Parameter(names = { "-o", "-output" }, description = "Output file name", converter = FileNameConverter.class)
	File outputFile;

	public File getOutputDir() {
		if (outputFile.getParentFile() == null) {
			return new File(".");
		}
		return outputFile.getParentFile();
	}

	@Parameter(names = "-help", help = true, description = "Produces this Output")
	private boolean help;

	public static class FileNameConverter implements IStringConverter<File> {
		@Override
		public File convert(String value) {
			return new File(value);
		}

	}

	@Getter
	private Path sourceFile;
	private Path basePath;

	public CommandLineParser(String path) throws InvalidOptionException {
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
	}

	private Path getNormalizedPath(String path) {
		return basePath.resolve(path).normalize();
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("parameters=\n");
		for (String param : parameters) {
			sb.append("\t" + param + "\n");
		}
		return sb.toString();

	}

	private boolean isFSFile(Path normalizedPath) throws InvalidOptionException {
		if (normalizedPath.toFile().exists()) {
			return normalizedPath.toFile().isFile()
					&& FileUtils.getExtension(normalizedPath.toString()).toLowerCase().equals("fs");
		} else {
			throw new InvalidOptionException("File not found\t" + normalizedPath.toString());
		}
	}

	private static Map<String, Path> fsFilesMap = new HashMap<>();

	public static void main(String[] args) {

		// Path basePath = FileSystems.getDefault().getPath("/");

		CommandLineParser clp = new CommandLineParser(new File("./").getAbsolutePath());
		try {
			System.out.println(System.setProperty(JCommander.DEBUG_PROPERTY, "debug"));
			JCommander jCommander = new JCommander(clp);
			jCommander.parse(args);
			System.out.println("Command=" + jCommander.getParsedCommand());

		} catch (ParameterException ex) {
			CommandLineParser.L.debug(ex.getMessage());
			System.out.println(ex.getMessage());
		}
		System.out.println(clp);
		try {
			clp.processParametersForForgeSpecFiles();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			CommandLineParser.L.debug(e.getMessage());
		}

	}

	private void processParametersForForgeSpecFiles() throws FileNotFoundException {
		for (String param : parameters) {
			Path normalizedPath = getNormalizedPath(param);
			if (isFSFile(normalizedPath)) {
				CommandLineParser.fsFilesMap.put(normalizedPath.toString(), normalizedPath);
			}
		}
	}

}
