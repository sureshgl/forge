package com.forge.hashtable;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.memogen.MemogenTest;
import com.forge.parser.ForgeUtils;
import com.forge.parser.data.HashTable;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;


public class getHashTableHintsTest {
	
	private static final Map<Integer, List<String>> HashHintMap = new HashMap<>();

	static {
		HashHintMap.put(0, Arrays.asList("zt_des_1s1su_1r1ru"));
		HashHintMap.put(1, Arrays.asList("zt_des_2s1su_1r1ru","zt_des_1r1su_1r1ru"));
		HashHintMap.put(2, Arrays.asList("zt_des_2r1su_1r1ru"));
	}
	
	@Test
	public void getHashTableHints() throws IOException {
		String forgeSpecFile = "test/com/forge/hashtable/ex.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
		for(int i=0;i<hashtables.size();i++){
			List<String> hintModules = hashtables.get(i).getModulesToInstantiate();
			List<String> expectedHintModules = HashHintMap.get(i);
			for(String moduleName : hintModules){
				if(!expectedHintModules.contains(moduleName))
					Assert.fail();
			}
		}
		Assert.assertTrue(true);
	}

}
