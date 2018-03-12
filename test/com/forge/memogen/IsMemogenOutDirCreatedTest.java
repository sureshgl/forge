package com.forge.memogen;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;

import org.junit.Assert;
import org.junit.Test;
import com.forge.runner.ForgeRunnerSession;

public class IsMemogenOutDirCreatedTest {
	
	@Test
	public void IsMemogenOutDirCreated() throws IOException {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File out = new File("./resources/isMemogenOutDirCreated");
		File tempaltes = new File("./templates/hw");
		ForgeRunnerSession frs = new ForgeRunnerSession(out, forgeSpecFile, false, tempaltes,new HashMap<String,String>());
		frs.run();
		File check = new File(out.toString()+"/memogen");
		if(check.exists())
			Assert.assertTrue(true);
		else 
			Assert.fail();
		out.delete();
	}
}
