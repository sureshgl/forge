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
import com.forge.parser.IR.IRegister;
import com.forge.parser.gen.ForgeParser.ArrayContext;
import com.forge.parser.gen.ForgeParser.RegisterContext;
import com.forge.parser.gen.ForgeParser.Register_listContext;
import com.forge.parser.gen.ForgeParser.Register_propertiesContext;
import com.forge.parser.gen.ForgeParser.Start_offsetContext;
import com.forge.runner.ForgeRunnerSession;

public class RegisterContextExt extends AbstractBaseExt implements IRegister {
	private Logger L = LoggerFactory.getLogger(RegisterContextExt.class);
	String regName = null;

	public RegisterContextExt(RegisterContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RegisterContext getContext() {
		return (RegisterContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).register());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RegisterContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RegisterContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	protected int offset;

	@Override
	public void calculateRegisterOffset(AtomicInteger offset) {
		/*
		 * Pick the overriden offset value(if any) and update the offset input 
		 * parameter accordingly
		 */
		/*
		 * 1. Get the totalSize of the Register(or RegisterArray) in words. 2. Get the
		 * totalSize adjusted to its nearest POT, totalSizeAlignedToPOT 3. Offset is an
		 * integral multiple of totalSizeAlignedToPOT.
		 */
		RegisterContext ctx = getContext();
		Integer overriden_offset = getOverridenOffset();
		if(overriden_offset != null){
			if(offset.get() > overriden_offset.intValue()){
				L.error("The provided offset for the register "+getName()+" is unacceptable. Please verify");
			} else {
				offset.set(overriden_offset.intValue());
			}
		}
		int totalSizeInWords = getTotalSizeInWords();
		int totalSizeAlignedToPOT = 1 << (int) Math.ceil(Math.log10(totalSizeInWords) / Math.log10(2));
		if (ctx.register_list() != null && !ctx.register_list().extendedContext.getFormattedText().equals("")) {
			if (offset.get() % totalSizeAlignedToPOT > 0) {
				int integralMultiple = offset.get() / totalSizeAlignedToPOT;
				this.offset = totalSizeAlignedToPOT * (integralMultiple + 1);
			} else {
				this.offset = offset.get();
			}
			offset.set(this.offset + totalSizeAlignedToPOT);
		} else {
			this.offset = offset.getAndAdd(totalSizeInWords);
		}
		// System.out.println("***" + (this.offset + (getTotalSizeInWords() * 1)));
		// System.out.println(ctx.register_identifier().extendedContext.getFormattedText() + "\t" + this.offset +
		// "\t"+ ((this.offset+totalSizeInWords)-1));
	}

	private Integer getOverridenOffset() {
		RegisterContext ctx = getContext();
		for(Register_propertiesContext register_propertiesContext : ctx.register_properties()){
			if(register_propertiesContext.start_offset() != null && !register_propertiesContext.start_offset().extendedContext.getFormattedText().equals("")){
				Start_offsetContext start_offsetContext = register_propertiesContext.start_offset();
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
	public void calculateFieldOffset(AtomicInteger offset) {
		RegisterContext ctx = getContext();
		offset.set(0);
		for (int i = 0; i < ctx.register_properties().size(); i++) {
			getExtendedContextVisitor().visit(ctx.register_properties(i)).calculateFieldOffset(offset);
		}
	}

	@Override
	protected void arrayPropertyCheck(String parentName) {
		RegisterContext ctx = getContext();
		String name = ctx.register_identifier().extendedContext.getFormattedText();
		super.arrayPropertyCheck(name);
	}

	@Override
	public void getIdentifier(List<String> idList) {
		RegisterContext ctx = getContext();
		idList.add(ctx.register_identifier().extendedContext.getFormattedText());
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		RegisterContext ctx = getContext();
		String name = ctx.register_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"Register has duplicate block with " + name + " in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
		List<String> groupInRegister = new ArrayList<>();
		for (Register_propertiesContext register_propertiesContext : ctx.register_properties()) {
			register_propertiesContext.extendedContext.duplicateNamesCheck(name, groupInRegister);
		}
	}

	@Override
	public String getName() {
		RegisterContext ctx = getContext();
		return ctx.register_identifier().extendedContext.getFormattedText();
	}

	@Override
	public Integer getArraySize() {
		RegisterContext ctx = getContext();
		if (ctx.register_list() != null) {
			return Integer.parseInt(ctx.register_list().array().max_size().extendedContext.getFormattedText())
					- Integer.parseInt(ctx.register_list().array().min_size().extendedContext.getFormattedText()) + 1;
		}
		return 1;
	}

	@Override
	public String getReadMask() {
		String readMask = "";
		RegisterContext ctx = getContext();
		List<IRegister> registerList = ctx.extendedContext.getRegisters();
		for (IRegister register : registerList) {
			for (IField field : register.getFields()) {
				for (int i = 0; i < field.getSize(); i++) {
					if (field.hasReadAttribute()) {

						readMask = 1 + readMask;
					} else {
						readMask = 0 + readMask;
					}
				}
			}
			readMask = Integer.toHexString(Integer.parseInt(readMask, 2));
		}
		return readMask;
	}

	@Override
	public String getWriteMask() {
		String writeMask = "";
		RegisterContext ctx = getContext();
		List<IRegister> registerList = ctx.extendedContext.getRegisters();
		for (IRegister register : registerList) {
			for (IField field : register.getFields()) {
				for (int i = 0; i < field.getSize(); i++) {
					if (field.hasReadAttribute()) {
						writeMask = 1 + writeMask;
					} else {
						writeMask = 0 + writeMask;
					}
				}
			}
			writeMask = Integer.toHexString(Integer.parseInt(writeMask, 2));
		}
		return writeMask;
	}

	@Override
	public List<IField> getFields() {
		RegisterContext ctx = getContext();
		List<IField> fieldList = new ArrayList<>();
		for (int i = 0; i < ctx.register_properties().size(); i++) {
			fieldList.addAll(ctx.register_properties(i).extendedContext.getFields());
		}
		return fieldList;
	}

	@Override
	public Integer getTotalSize() {
		IField field = getFields().get(getFields().size()-1);
		return field.getOffset() + field.getSize();
	}

	@Override
	public Integer getTotalSizeInWords() {
		int totalSize = getSizeInWords();
		RegisterContext ctx = getContext();
		if (ctx.register_list() != null) {
			Register_listContext reg_arrayContext = ctx.register_list().extendedContext.getContext();
			ArrayContext arrayContext = reg_arrayContext.array().extendedContext.getContext();
			int min_size = Integer.parseInt(arrayContext.min_size().extendedContext.getFormattedText());
			int max_size = Integer.parseInt(arrayContext.max_size().extendedContext.getFormattedText());
			int arrayLength = max_size - min_size + 1;
			totalSize = totalSize * arrayLength;
		}
		return totalSize;
	}

	@Override
	public Integer getSizeInWords() {
		int totalSize = getTotalSize();
		if (totalSize % 32 > 0) {
			totalSize = totalSize / 32 + 1;
		} else {
			totalSize = totalSize / 32;
		}
		return totalSize;
	}

	@Override
	public Integer getRegisterOffset() {
		return this.offset;
	}

	@Override
	public Integer getRegisterWordWidth() {
		// remove
		return (getNumberofBeats() + 1) * 32;
	}

	@Override
	public Integer getNumberofBeats() {
		// remove
		return (int) Math.floor(getTotalSize() / 32);
	}

	@Override
	public Integer getRnaxiWords() {
		return (int) Math.ceil(getTotalSize() / 32.0);
	}

	@Override
	public Integer getRnaxiWordsWidth() {
		return getRnaxiWords() * 32;
	}

	@Override
	public List<IRegister> getRegisters() {
		List<IRegister> registerList = new ArrayList<>();
		registerList.add(this);
		return registerList;
	}

	@Override
	public void requiredPropertyCheck() {
		RegisterContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		String name = ctx.register_identifier().extendedContext.getFormattedText();
		propStore.put("propName", name);
		for (int i = 0; i < ctx.register_properties().size(); i++) {
			ctx.register_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("group")) {
			throw new IllegalStateException(
					"In Register " + name + " group is not present in line " + ctx.start.getLine());
		}
	}

	private ST templateVHeaderRender(String InstanceOf) {
		STGroupFile grp = new STGroupFile("gen/vHeader.stg");
		grp.registerRenderer(String.class, new StringRenderer());
		ST stringTemplate = grp.getInstanceOf(InstanceOf);
		return stringTemplate;
	}

	@Override
	public ST getVHeaderRegister(ForgeRunnerSession forgeRunnerSession) {
		List<ST> stList = new ArrayList<>();
		ST VHeaderRegisterSt = templateVHeaderRender("VHeaderRegister");
		stList.addAll(this.getVHeaderRegisterStructureST(forgeRunnerSession));
		VHeaderRegisterSt.add("StList", stList);
		return VHeaderRegisterSt;
	}

	@Override
	public List<ST> getVHeaderRegisterStructureST(ForgeRunnerSession forgeRunnerSession) {
		RegisterContext ctx = getContext();
		List<ST> stList = new ArrayList<>();
		if (ctx.register_list() != null) {
			Register_listContext reg_arrayContext = ctx.register_list().extendedContext.getContext();
			ArrayContext arrayContext = reg_arrayContext.array().extendedContext.getContext();
			int min_size = Integer.parseInt(arrayContext.min_size().extendedContext.getFormattedText());
			int max_size = Integer.parseInt(arrayContext.max_size().extendedContext.getFormattedText());

			for (Integer reg_instance = min_size; reg_instance <= max_size; reg_instance++) {
				ST vHeaderRegisterStructureSt = templateVHeaderRender("VHeaderRegisterStructure");
				vHeaderRegisterStructureSt.add("reg_name", this.getName().toUpperCase());
				vHeaderRegisterStructureSt.add("reg_index", reg_instance);
				vHeaderRegisterStructureSt.add("start_offset", this.getStartOffset(reg_instance));
				vHeaderRegisterStructureSt.add("reg_total_size", this.getTotalSize());
				vHeaderRegisterStructureSt.add("reg_total_size_in_words", this.getTotalSizeInWords() / (max_size + 1));
				ST stFields = getVHeaderFieldStructureST(reg_instance);
				stList.add(vHeaderRegisterStructureSt);
				stList.add(stFields);
			}
		} else {
			ST vHeaderRegisterStructureSt = templateVHeaderRender("VHeaderRegisterStructure");
			vHeaderRegisterStructureSt.add("reg_name", this.getName().toUpperCase());
			vHeaderRegisterStructureSt.add("reg_index", 0);
			vHeaderRegisterStructureSt.add("start_offset", this.getStartOffset());
			vHeaderRegisterStructureSt.add("reg_total_size", this.getTotalSize());
			vHeaderRegisterStructureSt.add("reg_total_size_in_words", this.getTotalSizeInWords());
			ST stFields = getVHeaderFieldStructureST(0);
			stList.add(vHeaderRegisterStructureSt);
			stList.add(stFields);

		}
		return stList;
	}

	@Override
	public String getStartOffset() {
		return Integer.toHexString(this.offset);
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
	public String getEndOffset(int index) {
		int regOffset = 0;
		if (getArraySize() > index) {
			regOffset = Integer.valueOf(getStartOffset(index), 16) + getSizeInWords();
		} else {
			L.warn("Index overflow for register " + getName());
		}
		return Integer.toHexString(regOffset - 1);
	}

	@Override
	public String getEndOffset() {
		return Integer.toHexString(this.offset + getTotalSizeInWords() - 1);
	}

	@Override
	public ST getVHeaderFieldStructureST(Integer registerInstance) {
		RegisterContext ctx = getContext();
		ST vHeaderFieldDeclarationsSt = templateVHeaderRender("VHeaderFieldDeclarations");
		List<ST> vHeaderFieldDeclarationsStList = new ArrayList<>();
		List<IField> fieldList = ctx.extendedContext.getFields();
		for (IField field : fieldList) {
			ST vHeaderFieldDeclarationst = templateVHeaderRender("VHeaderFieldDeclaration");
			vHeaderFieldDeclarationst.add("reg_name", this.getName().toUpperCase());
			vHeaderFieldDeclarationst.add("reg_index", registerInstance);
			vHeaderFieldDeclarationst.add("field_name", field.getName().toUpperCase());
			vHeaderFieldDeclarationst.add("field_size", field.getSize());
			vHeaderFieldDeclarationst.add("field_start_offset", Integer.parseInt(field.getStartOffset(), 16));
			vHeaderFieldDeclarationst.add("field_range", field.getRangeInDecimal());
			vHeaderFieldDeclarationst.add("field_rst_value", field.getRstValue());
			vHeaderFieldDeclarationsStList.add(vHeaderFieldDeclarationst);
		}
		vHeaderFieldDeclarationsSt.add("VHeaderFieldDeclarationList", vHeaderFieldDeclarationsStList);
		return vHeaderFieldDeclarationsSt;
	}

	@Override
	public List<Integer> getArray() {
		List<Integer> ret = new ArrayList<>();
		for (int i = 0; i < getArraySize(); i++) {
			ret.add(i);
		}
		return ret;
	}
}
