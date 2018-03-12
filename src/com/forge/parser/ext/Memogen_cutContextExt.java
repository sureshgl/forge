package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.gen.ForgeParser.Memogen_cutContext;
import com.forge.parser.gen.ForgeParser.Memory_propertiesContext;

import lombok.Setter;

public class Memogen_cutContextExt extends AbstractBaseExt implements IMemogenCut{

	@Setter
	private Integer instanceNumber;
	private static final Logger L = LoggerFactory.getLogger(Memogen_cutContextExt.class);

	public Memogen_cutContextExt(Memogen_cutContext ctx) {
		addToContexts(ctx);
		parent = ctx;
		instanceNumber = null;
	}

	public Memogen_cutContextExt(Memogen_cutContext ctx,Integer instanceNumber) {
		addToContexts(ctx);
		parent = ctx;
		this.instanceNumber = instanceNumber;
	}

	@Override
	public Memogen_cutContext getContext() {
		return (Memogen_cutContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memogen_cut());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memogen_cutContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Memogen_cutContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public String getNameForMemogen() {
		Memogen_cutContext ctx = getContext();
		return ctx.memory_identifier().extendedContext.getFormattedText();
	}

	@Override
	public String getWords() {
		Memogen_cutContext ctx = getContext();
		Integer IWords = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).words() != null) {
				IWords = ctx.memory_properties(i).words().extendedContext.getWords();

			}
		}
		return IWords.toString();
	}

	@Override
	public String getReadPortValue() {
		Integer readPortValue = readPortValue();
		if (readPortValue == null) {
			throw new UnsupportedOperationException("No read port value in port cap");
		} else {
			return readPortValue.toString();
		}
	}

	@Override
	public String getWritePortValue() {
		Integer writePortValue = writePortValue();
		if (writePortValue == null) {
			throw new UnsupportedOperationException("No read port value in port cap");
		} else {
			return writePortValue.toString();
		}
	}

	@Override
	public String getBits() {
		Memogen_cutContext ctx = getContext();
		Integer IBits = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).bits() != null) {
				IBits = ctx.memory_properties(i).bits().extendedContext.getBits();
			}
		}
		return IBits.toString();
	}

	public Integer getArraySize() {
		Memogen_cutContext ctx = getContext();
		if (ctx.memory_list() != null) {
			return Integer.parseInt(ctx.memory_list().array().max_size().extendedContext.getFormattedText())
					- Integer.parseInt(ctx.memory_list().array().min_size().extendedContext.getFormattedText()) + 1;
		}
		return 1;
	}

	public List<IMemogenCut> getMemogenCuts() {
		List<IMemogenCut> cuts = new ArrayList<IMemogenCut>();
		Memogen_cutContext copy = (Memogen_cutContext)new PopulateExtendedContextVisitor().visit(getContext(getFormattedText()));
		copy.extendedContext.setInstanceNumber(0);
		cuts.add(copy.extendedContext);
		return cuts;
	}

	@Override
	public String getPortCap() {
		Memogen_cutContext ctx = getContext();
		String portCap = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).portCap() != null) {
				portCap = ctx.memory_properties(i).portCap().extendedContext.getPortCap();
			}
		}
		return portCap;		
	}

	@Override
	public String getInstanceNameForMemogen() {
		Memogen_cutContext ctx = getContext();
		if(instanceNumber == null){
			L.error("Instance number missing. Something wrong");
			System.exit(1);
		}
		return ctx.memory_identifier().extendedContext.getFormattedText()+"_"+instanceNumber;
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {

	}
	
	@Override
	public String getMemogenCmdLine(){
		Memogen_cutContext ctx = getContext();
		for(Memory_propertiesContext memory_propertiesContext : ctx.memory_properties()){
			if(memory_propertiesContext.hint_memogen()!= null){
				String cmd = memory_propertiesContext.hint_memogen().STRING().getText();
				return cmd.substring(1, cmd.length()-1).replace("\\", "");
			}
		}
		return null;
	}
}