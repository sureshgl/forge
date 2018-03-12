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

public class OffsetCalculationTest {
	private static final Map<String, Pair<String, String>> offSetStartEndMap = new HashMap<>();
	static {
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_1_0",
				new Pair<>(Integer.toHexString(0), Integer.toHexString(4))); // words 5
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_2_0",
				new Pair<>(Integer.toHexString(6), Integer.toHexString(6))); // words 1
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_2_1",
				new Pair<>(Integer.toHexString(7), Integer.toHexString(7))); // words 1
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_0",
				new Pair<>(Integer.toHexString(8), Integer.toHexString(9))); // words 2
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_1",
				new Pair<>(Integer.toHexString(10), Integer.toHexString(11))); // words 2
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_3_2",
				new Pair<>(Integer.toHexString(12), Integer.toHexString(13))); // words 2
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_0",
				new Pair<>(Integer.toHexString(32), Integer.toHexString(35))); // words 4
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_1",
				new Pair<>(Integer.toHexString(36), Integer.toHexString(39))); // words 4
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_2",
				new Pair<>(Integer.toHexString(40), Integer.toHexString(43))); // words 4
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_3",
				new Pair<>(Integer.toHexString(44), Integer.toHexString(47))); // words 4
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_4_4",
				new Pair<>(Integer.toHexString(48), Integer.toHexString(51))); // words 4

		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_0",
				new Pair<>(Integer.toHexString(128), Integer.toHexString(137))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_1",
				new Pair<>(Integer.toHexString(138), Integer.toHexString(147))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_2",
				new Pair<>(Integer.toHexString(148), Integer.toHexString(157))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_3",
				new Pair<>(Integer.toHexString(158), Integer.toHexString(167))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_4",
				new Pair<>(Integer.toHexString(168), Integer.toHexString(177))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_5",
				new Pair<>(Integer.toHexString(178), Integer.toHexString(187))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_6",
				new Pair<>(Integer.toHexString(188), Integer.toHexString(197))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_7",
				new Pair<>(Integer.toHexString(198), Integer.toHexString(207))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_8",
				new Pair<>(Integer.toHexString(208), Integer.toHexString(217))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_9",
				new Pair<>(Integer.toHexString(218), Integer.toHexString(227))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_10",
				new Pair<>(Integer.toHexString(228), Integer.toHexString(237))); // words 10
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_5_11",
				new Pair<>(Integer.toHexString(238), Integer.toHexString(247))); // words 10

		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_6_0",
				new Pair<>(Integer.toHexString(256), Integer.toHexString(256))); // words 1
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_7_0",
				new Pair<>(Integer.toHexString(257), Integer.toHexString(257))); // words 15
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_8_0",
				new Pair<>(Integer.toHexString(288), Integer.toHexString(302))); // words 15
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_8_1",
				new Pair<>(Integer.toHexString(303), Integer.toHexString(317))); // words 15

		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_9_0",
				new Pair<>(Integer.toHexString(512), Integer.toHexString(537))); // words 25
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_9_1",
				new Pair<>(Integer.toHexString(538), Integer.toHexString(563))); // words 8
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_9_2",
				new Pair<>(Integer.toHexString(564), Integer.toHexString(589))); // words 8
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_9_3",
				new Pair<>(Integer.toHexString(590), Integer.toHexString(615))); // words 8
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_9_4",
				new Pair<>(Integer.toHexString(616), Integer.toHexString(641))); // words 8

		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_10_0",
				new Pair<>(Integer.toHexString(768), Integer.toHexString(774))); // words 7
		OffsetCalculationTest.offSetStartEndMap.put("drmt_reg_10_1",
				new Pair<>(Integer.toHexString(775), Integer.toHexString(781))); // words 7
		OffsetCalculationTest.offSetStartEndMap.put("sm_mem_0",
				new Pair<>(Integer.toHexString(800), Integer.toHexString(831))); // words 32
		OffsetCalculationTest.offSetStartEndMap.put("sm_mem1_0",
				new Pair<>(Integer.toHexString(832), Integer.toHexString(895))); // words 32
		OffsetCalculationTest.offSetStartEndMap.put("sm_mem1_1",
				new Pair<>(Integer.toHexString(896), Integer.toHexString(959))); // words 32
		OffsetCalculationTest.offSetStartEndMap.put("sm_mem2_0",
				new Pair<>(Integer.toHexString(1024), Integer.toHexString(1279))); // words 128

	}

	@Test
	public void startEndofftest() throws Exception {
		FileParser fp = new FileParser();
		String forgeSpecFile = "test/com/forge/parser/regList.fs";
		File forgeSpec = new File(forgeSpecFile);
		StartContext sc = fp.getFileContent(forgeSpec);
		AtomicInteger offset = new AtomicInteger();
		sc.extendedContext.calculateOffset(offset);
		List<Register> registerList = ForgeUtils.getRegisters(sc);
		List<Memory> memoryList = ForgeUtils.getMemories(sc);
		for (Register register : registerList) {
			for (RegInstance regInst : register.getInstances()) {
				System.out.println(regInst.getName() + "=="
						+ OffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).first() + "=="
						+ OffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).second()
						+ regInst.getStartOffset());
				org.junit.Assert.assertTrue(OffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).first()
						.equals(regInst.getStartOffset()));
				System.out.println("hellow");
				org.junit.Assert.assertTrue(OffsetCalculationTest.offSetStartEndMap.get(regInst.getName()).second()
						.equals(regInst.getEndOffset()));
			}
		}
		for (Memory memory : memoryList) {
			for (MemInstance memInstance : memory.getInstances()) {
				System.out.println(memInstance.getName() + "=="
						+ OffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).first() + "=="
						+ OffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).second()
						+ memInstance.getStartOffset());
				System.out.println(memInstance.getStartOffset());
				System.out.println(memInstance.getEndOffset());
				org.junit.Assert.assertTrue(OffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).first()
						.equals(memInstance.getStartOffset()));
				org.junit.Assert.assertTrue(OffsetCalculationTest.offSetStartEndMap.get(memInstance.getName()).second()
						.equals(memInstance.getEndOffset()));
			}
		}
	}
}
