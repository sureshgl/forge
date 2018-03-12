package com.forge.hashtable;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.ForgeUtils;
import com.forge.parser.data.HashTable;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class getHashTablesTest {

	@Test
	public void getHashTable() throws IOException {
		String forgeSpecFile = "test/com/forge/hashtable/ex.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
		Assert.assertTrue(hashtables.size() == 3);
	}

}
