package com.forge.parser;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.Test;

import com.forge.common.Utils.Pair;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.data.RegInstance;
import com.forge.parser.data.Register;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class DesiredOffsetCalculationTest {

	private static final Map<String, Pair<String, String>> offSetStartEndMap = new HashMap<>();

		
	static {
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_1_0",
				new Pair<>(Integer.toHexString(0), Integer.toHexString(4))); // words 5
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_2_0",
				new Pair<>(Integer.toHexString(6), Integer.toHexString(6))); // words 1
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_2_1",
				new Pair<>(Integer.toHexString(7), Integer.toHexString(7))); // words 1
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_0",
				new Pair<>(Integer.toHexString(256), Integer.toHexString(257))); // words 2
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_1",
				new Pair<>(Integer.toHexString(258), Integer.toHexString(259))); // words 2
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_2",
				new Pair<>(Integer.toHexString(260), Integer.toHexString(261))); // words 2
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_0",
				new Pair<>(Integer.toHexString(288), Integer.toHexString(291))); // words 4
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_1",
				new Pair<>(Integer.toHexString(292), Integer.toHexString(295))); // words 4
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_2",
				new Pair<>(Integer.toHexString(296), Integer.toHexString(299))); // words 4
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_3",
				new Pair<>(Integer.toHexString(300), Integer.toHexString(303))); // words 4
		DesiredOffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_4",
				new Pair<>(Integer.toHexString(304), Integer.toHexString(307))); // words 4

		DesiredOffsetCalculationTest.offSetStartEndMap.put("sm_mem_0",
				new Pair<>(Integer.toHexString(1536), Integer.toHexString(1567))); // words 32
		DesiredOffsetCalculationTest.offSetStartEndMap.put("sm_mem1_0",
				new Pair<>(Integer.toHexString(1600), Integer.toHexString(1663))); // words 32
		DesiredOffsetCalculationTest.offSetStartEndMap.put("sm_mem1_1",
				new Pair<>(Integer.toHexString(1664), Integer.toHexString(1727))); // words 32
		DesiredOffsetCalculationTest.offSetStartEndMap.put("sm_mem2_0",
				new Pair<>(Integer.toHexString(2048), Integer.toHexString(2303))); // words 128

	}

	@Test
	public void startEndofftest() throws Exception {
		FileParser fp = new FileParser();
		String forgeSpecFile = "test/com/forge/parser/desiredOffset.fs";
		File forgeSpec = new File(forgeSpecFile);
		StartContext sc = fp.getFileContent(forgeSpec);
		AtomicInteger offset = new AtomicInteger();
		sc.extendedContext.calculateOffset(offset);
		List<Register> registerList = ForgeUtils.getRegisters(sc);
		List<Memory> memoryList = ForgeUtils.getMemories(sc);
		for (Register register : registerList) {
			for (RegInstance regInst : register.getInstances()) {
				System.out.println(regInst.getName());
				System.out.println(regInst.getStartOffset());
				System.out.println(DesiredOffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).first());
				System.out.println(regInst.getEndOffset());
				System.out.println(DesiredOffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).second());
				System.out.println();
				org.junit.Assert.assertTrue(DesiredOffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).first()
						.equals(regInst.getStartOffset()));
				org.junit.Assert.assertTrue(DesiredOffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).second()
						.equals(regInst.getEndOffset()));
			}
		}
		for (Memory memory : memoryList) {
			for (MemInstance memInstance : memory.getInstances()) {
				System.out.println(memInstance.getName());
				System.out.println(memInstance.getStartOffset());
				System.out.println(DesiredOffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).first());
				System.out.println(memInstance.getEndOffset());
				System.out.println(DesiredOffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).second());
				System.out.println();
				org.junit.Assert.assertTrue(DesiredOffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).first()
						.equals(memInstance.getStartOffset()));
				org.junit.Assert.assertTrue(DesiredOffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).second()
						.equals(memInstance.getEndOffset()));
			}
		}
	}
}
