package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;
import org.stringtemplate.v4.StringRenderer;

import com.forge.parser.ForgeUtils;
import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IHashTable;
import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.IR.IMemory;
import com.forge.parser.IR.IRegister;
import com.forge.parser.IR.IStart;
import com.forge.parser.gen.ForgeParser.Constarint_listContext;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.ForgeRunnerSession;

public class StartContextExt extends AbstractBaseExt implements IStart {

	public StartContextExt(StartContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StartContext getContext() {
		return (StartContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).start());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StartContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StartContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public List<IRegister> getRegisters() {
		StartContext ctx = getContext();
		List<IRegister> registerList = new ArrayList<>();
		for (int i = 0; i < ctx.constarint_list().size(); i++) {
			registerList.addAll(ctx.constarint_list(i).extendedContext.getRegisters());
		}

		return registerList;
	}

	@Override
	public List<IMemory> getMemories() {
		StartContext ctx = getContext();
		List<IMemory> memoryList = new ArrayList<>();
		for (int i = 0; i < ctx.constarint_list().size(); i++) {
			memoryList.addAll(ctx.constarint_list(i).extendedContext.getMemories());
		}
		return memoryList;
	}
	
	@Override
	public void getverilogHeader(ForgeRunnerSession forgeRunnerSession) {
		StartContext ctx = getContext();
		STGroupFile grp = new STGroupFile("gen/vHeader.stg");
		grp.registerRenderer(String.class, new StringRenderer());
		ST cBlocksSt = grp.getInstanceOf("VHeaderBlocks");
		List<ST> stList = new ArrayList<>();
		//AtomicInteger offset = new AtomicInteger();
		//ctx.extendedContext.calculateOffset(offset);
		List<IRegister> registerList = ctx.extendedContext.getRegisters();
		List<IMemory> memoryList = ctx.extendedContext.getMemories();
		for (IRegister register : registerList) {
			stList.add(register.getVHeaderRegister(forgeRunnerSession));
		}
		for (IMemory memory : memoryList) {
			stList.add(memory.getVHeaderMemory(forgeRunnerSession));
		}
		cBlocksSt.add("StList", stList);
		writeFile(forgeRunnerSession, cBlocksSt, ForgeUtils.getForgeSpecName(), ".vh");
	}

	@Override
	public List<String> getMemoryNames() {
		List<String> memoryNames = new ArrayList<>();
		for (IMemory iMem : getMemories()) {
			memoryNames.add(iMem.getName());
		}
		return memoryNames;
	}

	@Override
	public List<IHashTable> getHashTables() {
		StartContext ctx = getContext();
		List<IHashTable> hashTableList = new ArrayList<IHashTable>();
		for(Constarint_listContext constarint_listContext : ctx.constarint_list()){
			if(constarint_listContext.hashtable() != null){
				hashTableList.add((IHashTable) constarint_listContext.hashtable().extendedContext);
			}
		}
		return hashTableList;
	}

	@Override
	public List<IMemogenCut> getMemogenCuts() {
		StartContext ctx = getContext();
		List<IMemogenCut> memogenCuts = new ArrayList<IMemogenCut>();
		for(Constarint_listContext constarint_listContext : ctx.constarint_list()){
			if(constarint_listContext.memogen_cut() != null){
				memogenCuts.addAll(constarint_listContext.memogen_cut().extendedContext.getMemogenCuts());
			}
		}
		return memogenCuts;
	}
}
