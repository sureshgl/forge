package com.forge.parser;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.common.FileUtils;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;
import com.forge.runner.ForgeRunnerSession;

public class HeaderGenTest {

	@Test
	public void HeaderFileGen() throws FileNotFoundException {
		String forgeSpecFile = "test/com/forge/parser/headerGenInput.fs";

		FileParser fp = new FileParser();
		File forgeSpec = new File(forgeSpecFile);

		String outDir = "test/com/forge/parser/out";
		File out = new File(outDir);
		if (!out.exists()) {
			out.mkdirs();
		}
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(out, forgeSpec.toString(), false,
				new File("templates/hw"),new HashMap<String,String>());
		forgeRunnerSession.run();
		StartContext sc = fp.getFileContent(forgeSpec);
		sc.extendedContext.getverilogHeader(forgeRunnerSession);
		Assert.assertTrue(compareTwoFiles(outDir + "/headerGenInput.vh", "test/com/forge/parser/headerGenOutput.vh"));

		HeaderGenTest.cleanUp(out);
	}

	private static void cleanUp(File dir) {
		if (dir.exists()) {
			for (File file : FileUtils.allFilesInDir(dir.getAbsolutePath())) {
				file.delete();
			}
			dir.deleteOnExit();
			;
		}
	}

	public boolean compareTwoFiles(String file1Path, String file2Path) {
		Path p1 = Paths.get(file1Path);
		Path p2 = Paths.get(file2Path);

		try {
			List<String> listF1 = Files.readAllLines(p1);
			List<String> listF2 = Files.readAllLines(p2);
			return listF1.containsAll(listF2);

		} catch (IOException ie) {
			return false;
		}

	}

}
