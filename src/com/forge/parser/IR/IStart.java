package com.forge.parser.IR;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import com.forge.runner.ForgeRunnerSession;

public interface IStart {

	public void calculateOffset(AtomicInteger offset);

	public List<IMemory> getMemories();
	
	public List<IHashTable> getHashTables();

	public List<String> getMemoryNames();

	public List<IRegister> getRegisters();
	
	public List<IMemogenCut> getMemogenCuts();

	public void getverilogHeader(ForgeRunnerSession forgeRunnerSession);

}
