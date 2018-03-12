package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;
import org.stringtemplate.v4.StringRenderer;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IField;
import com.forge.parser.IR.IMemory;
import com.forge.parser.gen.ForgeParser.ArrayContext;
import com.forge.parser.gen.ForgeParser.MemoryContext;
import com.forge.parser.gen.ForgeParser.Memory_listContext;
import com.forge.parser.gen.ForgeParser.Memory_propertiesContext;
import com.forge.parser.gen.ForgeParser.Start_offsetContext;
import com.forge.runner.ForgeRunnerSession;

public class MemoryContextExt extends AbstractBaseExt implements IMemory {
	private Logger L = LoggerFactory.getLogger(MemoryContextExt.class);

	public MemoryContextExt(MemoryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MemoryContext getContext() {
		return (MemoryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MemoryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MemoryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected List<String> getMemNames(String prefix) {
		MemoryContext ctx = getContext();
		List<String> memNames = new ArrayList<>();
		memNames.add(prefix + "_" + ctx.memory_identifier().extendedContext.getFormattedText());
		return memNames;
	}

	protected int offset;

	private Integer getOverridenOffset() {
		MemoryContext ctx = getContext();
		for(Memory_propertiesContext memory_propertiesContext : ctx.memory_properties()){
			if(memory_propertiesContext.start_offset() != null && !memory_propertiesContext.start_offset().extendedContext.getFormattedText().equals("")){
				Start_offsetContext start_offsetContext = memory_propertiesContext.start_offset();
				String hex_number =  start_offsetContext.id_or_number().extendedContext.getFormattedText();
				Pattern p = Pattern.compile("([1-9][_0-9]*)?'[sS]?[hH]([XxZz0-9a-fA-F][_XxZz0-9a-fA-F]*)");
				Matcher m = p.matcher(hex_number);
				if(m.matches())
					return Integer.parseInt(m.group(2),16);
				else {
					L.error("Incorrect hex value specified at Memory "+getName());
					System.exit(1);
				}
			}
		}
		return null;
	}

	@Override
	public void calculateMemoryOffset(AtomicInteger offset) {
		Integer overriden_offset = getOverridenOffset();
		if(overriden_offset != null){
			if(offset.get() > overriden_offset.intValue()){
				L.error("The provided offset for the register "+getName()+" is unacceptable. Please verify");
			} else {
				offset.set(overriden_offset.intValue());
			}
		}
		int totalSizeInWords = getSizeInWords(); // May not be in powers of 2
		int arraySize = getArraySize();
		int totalSizeAlignedToPOT = 1 << (int) Math.ceil(Math.log10(totalSizeInWords) / Math.log10(2)); // only Words
		// are move to
		// powers of 2
		if (offset.get() % totalSizeAlignedToPOT > 0) {
			int integralMultiple = offset.get() / totalSizeAlignedToPOT;
			this.offset = totalSizeAlignedToPOT * (integralMultiple + 1);
		} else {
			this.offset = offset.get();
		}
		offset.set(this.offset + totalSizeAlignedToPOT * arraySize);
	}

	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		MemoryContext ctx = getContext();
		offset.set(0);
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			getExtendedContextVisitor().visit(ctx.memory_properties(i)).calculateFieldOffset(offset);
		}
	}

	@Override
	public void requiredPropertyCheck() {
		MemoryContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		String name = ctx.memory_identifier().extendedContext.getFormattedText();
		propStore.put("propName", name);
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			ctx.memory_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("words")) {
			throw new IllegalStateException("Memory " + name + " words not present in line" + ctx.start.getLine());
		}
		if (!propStore.containsKey("bits")) {
			throw new IllegalStateException("Memory" + name + "bits not present in line" + ctx.start.getLine());
		}
		if (!propStore.containsKey("portCap")) {
			throw new IllegalStateException("Memory" + name + "portCap not present in line" + ctx.start.getLine());
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		MemoryContext ctx = getContext();
		String name = ctx.memory_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In memory duplicate block with name " + name + " exists in line " + ctx.start.getLine());

		} else {
			blockNames.add(name);
		}
	}

	@Override
	public List<IMemory> getMemories() {
		List<IMemory> memoryList = new ArrayList<>();
		memoryList.add(this);
		return memoryList;
	}

	@Override
	public String getName() {
		MemoryContext ctx = getContext();
		return ctx.memory_identifier().extendedContext.getFormattedText();
	}

	@Override
	public void getIdentifier(List<String> idList) {
		MemoryContext ctx = getContext();
		idList.add(ctx.memory_identifier().extendedContext.getFormattedText());
	}

	@Override
	public Integer getRnaxiWordsWidth() {
		return getRnaxiWords() * 32;
	}

	@Override
	public Integer getRnaxiWords() {
		return (int) Math.ceil(getBits() / 32.0);
	}

	@Override
	public Integer getWords() {
		MemoryContext ctx = getContext();
		Integer IWords = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).words() != null) {
				IWords = ctx.memory_properties(i).words().extendedContext.getWords();

			}
		}
		return IWords;
	}

	@Override
	public Integer getBits() {
		MemoryContext ctx = getContext();
		Integer IBits = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).bits() != null) {
				IBits = ctx.memory_properties(i).bits().extendedContext.getBits();
			}
		}
		return IBits;
	}

	@Override
	public Integer getMemoryOffset() {
		return this.offset;
	}

	@Override
	public Integer getTotalSizeInWords() {
		int totalSize = 0;
		totalSize += this.getBits();
		if (totalSize % 32 > 0) {
			totalSize = totalSize / 32 + 1;
		} else {
			totalSize = totalSize / 32;
		}

		MemoryContext ctx = getContext();
		if (ctx.memory_list() != null) {
			Memory_listContext mem_arrayContext = ctx.memory_list().extendedContext.getContext();
			ArrayContext arrayContext = mem_arrayContext.array().extendedContext.getContext();
			int min_size = Integer.parseInt(arrayContext.min_size().extendedContext.getFormattedText());
			int max_size = Integer.parseInt(arrayContext.max_size().extendedContext.getFormattedText());
			int array_length = max_size - min_size + 1;
			totalSize = totalSize * array_length;
		}
		return this.getWords() * totalSize;
	}

	@Override
	public Integer getTotalSize() {
		return this.getWords() * this.getBits();
	}

	@Override
	public Integer getBitsInWords() {
		int totalBits = this.getBits();
		if (totalBits % 32 > 0) {
			totalBits = totalBits / 32 + 1;
		} else {
			totalBits = totalBits / 32;
		}
		return totalBits;
	}

	@Override
	public String getStartOffset() {
		return Integer.toHexString(this.offset);
	}

	@Override
	public String getEndOffset() {
		int totalSizeInWords = getSizeInWords(); // May not be in powers of 2
		int totalSizeAlignedToPOT = 1 << (int) Math.ceil(Math.log10(totalSizeInWords) / Math.log10(2));
		return Integer.toHexString(this.offset + totalSizeAlignedToPOT * getArraySize() - 1);
	}

	@Override
	public String getPortCap() {
		MemoryContext ctx = getContext();
		String portCap = null;
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			if (ctx.memory_properties(i).portCap() != null) {
				portCap = ctx.memory_properties(i).portCap().extendedContext.getPortCap();
			}
		}
		return portCap;		
	}

	@Override
	public Integer getSizeInWords() {
		return getWords() * getBitsInWords();
	}

	@Override
	public String getStartOffset(int index) {
		int regOffset = 0;
		if (getArraySize() > index) {
			regOffset = this.offset + getSizeInWords() * index;
		} else {
			L.warn("Index overflow for register " + getName());
		}
		return Integer.toHexString(regOffset);
	}

	@Override
	public Integer getArraySize() {
		MemoryContext ctx = getContext();
		if (ctx.memory_list() != null) {
			return Integer.parseInt(ctx.memory_list().array().max_size().extendedContext.getFormattedText())
					- Integer.parseInt(ctx.memory_list().array().min_size().extendedContext.getFormattedText()) + 1;
		}
		return 1;
	}

	@Override
	public String getEndOffset(int index) {
		int memOffset = 0;
		if (getArraySize() > index) {
			memOffset = Integer.valueOf(getStartOffset(index), 16) + getSizeInWords();
		} else {
			L.warn("Index overflow for register " + getName());
		}
		return Integer.toHexString(memOffset - 1);
	}

	@Override
	public List<IField> getFields() {
		MemoryContext ctx = getContext();
		List<IField> fieldList = new ArrayList<>();
		for (int i = 0; i < ctx.memory_properties().size(); i++) {
			fieldList.addAll(ctx.memory_properties(i).extendedContext.getFields());
		}
		return fieldList;
	}

	@Override
	public boolean hasInterfaceOnly() {
		if (getFields().size() == 0) {
			return false;
		}
		for (IField field : getFields()) {
			if (!field.hasInterfaceOnly()) {
				return false;
			}
		}
		return true;
	}

	@Override
	public Integer getLogOfWords() {
		Double d = Math.ceil(Math.log(getWords()) / Math.log(2));
		return d.intValue();
	}

	@Override
	public Integer getReadPortValue() {
		Integer readPortValue = readPortValue();
		if (readPortValue == null) {
			throw new UnsupportedOperationException("No read port value in port cap");
		} else {
			return readPortValue;
		}
	}

	@Override
	public Integer getWritePortValue() {
		Integer writePortValue = writePortValue();
		if (writePortValue == null) {
			throw new UnsupportedOperationException("No read port value in port cap");
		} else {
			return writePortValue;
		}
	}

	@Override
	public Integer getEccWidth() {
		return new Integer(0);
	}

	@Override
	public Boolean getIsWriteMultiport() {
		return getWritePortValue() > 1;
	}

	@Override
	public Boolean getIsReadMultiport() {
		return getReadPortValue() > 1;
	}

	private ST templateVHeaderRender(String InstanceOf) {
		STGroupFile grp = new STGroupFile("gen/vHeader.stg");
		grp.registerRenderer(String.class, new StringRenderer());
		ST stringTemplate = grp.getInstanceOf(InstanceOf);
		return stringTemplate;
	}

	@Override
	public ST getVHeaderMemory(ForgeRunnerSession forgeRunnerSession) {
		List<ST> stList = new ArrayList<>();
		ST VHeaderRegisterSt = templateVHeaderRender("VHeaderMemory");
		stList.addAll(this.getVHeaderMemoryStructureST(forgeRunnerSession));
		stList.add(this.getVHeaderFieldStructureST());
		VHeaderRegisterSt.add("StList", stList);
		return VHeaderRegisterSt;
	}

	@Override
	public List<ST> getVHeaderMemoryStructureST(ForgeRunnerSession forgeRunnerSession) {
		MemoryContext ctx = getContext();
		List<ST> stList = new ArrayList<>();
		if (ctx.memory_list() != null) {
			Memory_listContext mem_arrayContext = ctx.memory_list().extendedContext.getContext();
			ArrayContext arrayContext = mem_arrayContext.array().extendedContext.getContext();
			int min_size = Integer.parseInt(arrayContext.min_size().extendedContext.getFormattedText());
			int max_size = Integer.parseInt(arrayContext.max_size().extendedContext.getFormattedText());

			for (Integer i = min_size; i <= max_size; i++) {
				ST vHeaderRegisterStructureSt = templateVHeaderRender("VHeaderMemoryStructure");
				vHeaderRegisterStructureSt.add("mem_name", this.getName().toUpperCase());
				vHeaderRegisterStructureSt.add("mem_index", i);
				vHeaderRegisterStructureSt.add("start_offset", this.getStartOffset(i));
				vHeaderRegisterStructureSt.add("mem_words", this.getWords());
				vHeaderRegisterStructureSt.add("mem_bits", this.getBits());
				vHeaderRegisterStructureSt.add("mem_width_in_words", this.getBitsInWords());
				stList.add(vHeaderRegisterStructureSt);
			}
		} else {
			ST vHeaderRegisterStructureSt = templateVHeaderRender("VHeaderMemoryStructure");
			vHeaderRegisterStructureSt.add("mem_name", this.getName().toUpperCase());
			vHeaderRegisterStructureSt.add("start_offset", this.getStartOffset());
			vHeaderRegisterStructureSt.add("mem_words", this.getWords());
			vHeaderRegisterStructureSt.add("mem_bits", this.getBits());
			vHeaderRegisterStructureSt.add("mem_width_in_words", this.getBitsInWords());
			stList.add(vHeaderRegisterStructureSt);

		}
		return stList;
	}

	@Override
	public ST getVHeaderFieldStructureST() {
		MemoryContext ctx = getContext();
		ST vHeaderFieldDeclarationsSt = templateVHeaderRender("VHeaderFieldDeclarations");
		List<ST> vHeaderFieldDeclarationsStList = new ArrayList<>();
		List<IField> fieldList = ctx.extendedContext.getFields();
		for (IField field : fieldList) {
			ST vHeaderFieldDeclarationst = templateVHeaderRender("VHeaderFieldDeclaration");
			vHeaderFieldDeclarationst.add("reg_name", this.getName().toUpperCase());
			vHeaderFieldDeclarationst.add("field_name", field.getName().toUpperCase());
			vHeaderFieldDeclarationst.add("field_size", field.getSize());
			vHeaderFieldDeclarationst.add("field_start_offset", field.getStartOffset());
			vHeaderFieldDeclarationst.add("field_range", field.getRangeInDecimal());
			vHeaderFieldDeclarationst.add("field_rst_value", field.getRstValue());
			vHeaderFieldDeclarationsStList.add(vHeaderFieldDeclarationst);
		}
		vHeaderFieldDeclarationsSt.add("VHeaderFieldDeclarationList", vHeaderFieldDeclarationsStList);
		return vHeaderFieldDeclarationsSt;
	}

	@Override
	public String getMemogenCmdLine(){
		MemoryContext ctx = getContext();
		for(Memory_propertiesContext memory_propertiesContext : ctx.memory_properties()){
			if(memory_propertiesContext.hint_memogen()!= null){
				String cmd = memory_propertiesContext.hint_memogen().STRING().getText();
				return cmd.substring(1, cmd.length()-1).replace("\\", "");
			}
		}
		return null;
	}
}
