package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IField;
import com.forge.parser.gen.ForgeParser.AttributesContext;
import com.forge.parser.gen.ForgeParser.FieldContext;
import com.forge.runner.ForgeRunnerSession;

public class FieldContextExt extends AbstractBaseExt implements IField {

	private static final Logger L = LoggerFactory.getLogger(ForgeRunnerSession.class);

	public FieldContextExt(FieldContext ctx) {
		addToContexts(ctx);
		parent = ctx;
		isRead = null;
		isWrite = null;
		isIncrement = null;
		setType();
	}

	@Override
	public FieldContext getContext() {
		return (FieldContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof FieldContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + FieldContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	protected int offset;
	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		Integer fsize = getSize();
		Integer faln = getAlign();
		if(faln > 0){
			offset.set(offset.get() + faln - offset.get() % faln);
		}
		this.offset = offset.get();
		offset.set(fsize + this.offset);
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> names) {
		FieldContext ctx = getContext();
		String name = ctx.field_identifier().extendedContext.getFormattedText();
		if (names.contains(name)) {
			throw new IllegalStateException(
					"Duplicate field with name " + name + " inside " + parentName + " in line " + ctx.start.getLine());
		} else {
			names.add(name);
		}
	}

	@Override
	public String getName() {
		FieldContext ctx = getContext();
		return ctx.field_identifier().extendedContext.getFormattedText();
	}

	@Override
	public String getDes() {
		String des = null;
		FieldContext ctx = getContext();
		for (AttributesContext attributesContext : ctx.attributes()) {
			if(attributesContext.description_attr()!= null)
				des =  attributesContext.description_attr().STRING().getText();
		}
		return des;		
	}

	@Override
	public Integer getSize() {
		FieldContext ctx = getContext();
		try{
			return Integer.parseInt(ctx.size().id_or_number().extendedContext.getFormattedText());
		} catch (Exception e){
			throw new RuntimeException("Cannot cast string. Field's size at fault");
		}
	}

	@Override
	public Integer getAlign() {
		FieldContext ctx = getContext();
		if (ctx.field_part1() != null && ctx.field_part1().align() != null) {
			try{
				return Integer.parseInt(ctx.field_part1().align().extendedContext.getFormattedText());
			} catch(Exception e) {
				L.error("Cannot cast string. Field's align at fault");
				System.exit(1);
				return null;
			}
		} else {
			return 0;
		}
	}

	@Override
	public List<IField> getFields() {
		List<IField> fieldList = new ArrayList<>();
		fieldList.add(this);
		return fieldList;
	}

	@Override
	public Integer getOffset() {
		return this.offset;
	}
	
	@Override
	public String getStartOffset() {
		return Integer.toHexString(this.offset);
	}

	@Override
	public String getEndOffset() {
		return Integer.toHexString(this.offset + getSize() - 1);
	}

	@Override
	public String getRstValue() {
		FieldContext ctx = getContext();
		if (ctx.field_part3() != null) {
			return ctx.field_part3().rst_value().id_or_number().extendedContext.getFormattedText();
		} else {
			return this.getSize() + "'h0";
		}
	}

	@Override
	public String getRange() {
		return "[" + this.getStartOffset() + ":" + this.getEndOffset() + "]";
	}

	@Override
	public String getRangeInDecimal() {
		return "[" + (this.offset + getSize() - 1) + ":" + this.offset + "]";
	}
	
	@Override
	public boolean hasInterfaceOnly() {
		FieldContext ctx = getContext();
		if (!hasWriteAttribute() || !hasReadAttribute()) {
			return false;
		}
		for (AttributesContext attributesContext : ctx.attributes()) {
			if (attributesContext.write_attr() != null
					&& !attributesContext.write_attr().extendedContext.getFormattedText().contains("interface_only")) {
				return false;
			}
			if (attributesContext.read_attr() != null
					&& !attributesContext.read_attr().extendedContext.getFormattedText().contains("interface_only")) {
				return false;
			}
		}
		return true;
	}
	
	@Override
	public boolean hasTypeAttribute() {
		FieldContext ctx = getContext();
		for (AttributesContext attributesContext : ctx.attributes()) {
			if (attributesContext.type_attr() != null) {
				return true;
			}
		}
		return false;
	}

	@Override
	public boolean isTypeStatus() {
		return isType("status");
	}

	@Override
	public boolean isTypeConfig() {
		return isType(".config");
	}

	@Override
	public boolean isTypeCounter() {
		return isType(".counter");
	}

	@Override
	public boolean isTypeSatCounter() {
		return isType(".sat_counter");
	}
	
	@Override
	public boolean isAtomic(){
		return isType("atomic");
	}
	
	private boolean isType(String type){
		FieldContext ctx = getContext();
		for (AttributesContext attributesContext : ctx.attributes()) {
			if (attributesContext.type_attr() != null
					&& attributesContext.type_attr().extendedContext.getFormattedText().contains(type)) {
				return true;
			}			
		}		
		return false;
	}

	private Boolean isRead;
	private Boolean isWrite;
	private Boolean isIncrement;
	@Override
	public boolean isReadOnly() {
		if (!hasWriteAttribute() &&  hasReadAttribute()) {
			return true;
		}
		return false; 
	}

	@Override
	public boolean isWriteOnly() {
		if (hasWriteAttribute() &&  !hasReadAttribute()) {
			return true;
		}
		return false; 
	}

	@Override
	public boolean isReadWrite() {
		if (hasWriteAttribute() &&  hasReadAttribute()) {
			return true;
		}
		return false; 
	}

	private void setType(){
		FieldContext ctx = getContext();
		for (AttributesContext attributesContext : ctx.attributes()) {
			if (attributesContext.type_attr()!= null) {
				if(isTypeCounter() || isTypeSatCounter() ){
					if(isRead == null)
						isRead = true;
					if(isWrite == null)
						isWrite = true;
					if(isIncrement == null)
						isIncrement = false;
				} 
				if(isTypeStatus()){
					if(isRead == null)
						isRead = true;
					if(isWrite == null)
						isWrite = false;
				}
				if(isTypeConfig()){
					if(isRead == null)
						isRead = true;
					if(isWrite == null)
						isWrite = true;
				}
			}
		}
		for (AttributesContext attributesContext : ctx.attributes()) {
			if(attributesContext.read_attr() != null){
				if(isRead == null)
					isRead = true;
			}
			if(attributesContext.write_attr() != null){
				if(isWrite == null)
					isWrite = true;
			}
			if(attributesContext.read_attr() != null && attributesContext.read_attr().extendedContext.getFormattedText().contains("increment")){
				if(isIncrement == null)
					isIncrement = true;
			}
			if(attributesContext.write_attr() != null && attributesContext.write_attr().extendedContext.getFormattedText().contains("increment")){
				if(isIncrement == null)
					isIncrement = true;
			}
		}
	}

	@Override
	public boolean hasWriteAttribute() {
		if(isWrite != null)
			return isWrite;
		else
			return false;
	}

	@Override
	public boolean hasReadAttribute() {
		if(isRead != null)
			return isRead;
		else
			return false;
	}

	@Override
	public boolean hasIncrementAttribute() {
		if(isIncrement != null)
			return isIncrement;
		else
			return false;
	}
}
