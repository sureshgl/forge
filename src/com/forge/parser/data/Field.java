package com.forge.parser.data;

import java.util.concurrent.atomic.AtomicInteger;

import org.codehaus.jackson.annotate.JsonIgnore;

import com.forge.parser.IR.IField;

public class Field {

	@JsonIgnore
	private IField fld;

	private Integer accSize;

	public Field(IField fld) {
		this.fld = fld;
	}

	public Integer getAccSize() {
		return accSize;
	}

	public String getName() {
		return fld.getName();
	}

	public boolean getReadTrigger() {
		return fld.isReadTrigger();
	}

	public boolean getWriteTrigger() {
		return fld.isWriteTrigger();
	}

	public String getSize() {
		return fld.getSize().toString();
	}

	public String getRstValue() {
		return fld.getRstValue();
	}
	
	public String getDes() {
		return fld.getDes();
	}

	public boolean getReadClear() {
		return fld.isReadClear();
	}

	public String getRegDataRange() {
		Integer size = Integer.parseInt(getSize());
		return "[" + (getAccSize() + size - 1) + ":" + getAccSize() + "]";
	}

	public boolean getWriteAttribute() {
		return fld.hasWriteAttribute();
	}

	public boolean getWriteOnly() {
		return fld.isWriteOnly();
	}

	public boolean getTypeAttribute() {
		return fld.hasTypeAttribute();
	}

	public boolean getReadOnly() {
		return fld.isReadOnly();
	}

	public boolean getReadWrite() {
		return fld.isReadWrite();
	}

	public boolean getReadAttribute() {
		return fld.hasReadAttribute();
	}

	public boolean getIncrementAttribute() {
		return fld.hasIncrementAttribute();
	}

	public boolean getTypeStatus() {
		return fld.isTypeStatus();
	}

	public boolean getTypeConfig() {
		return fld.isTypeConfig();
	}

	public boolean getTypeCounter() {
		return fld.isTypeCounter();
	}

	public boolean getTypeSatCounter() {
		return fld.isTypeSatCounter();
	}

	public void calculateFieldAcc(AtomicInteger accSize2) {
		this.accSize = accSize2.intValue();
		accSize2.set(accSize2.get() + Integer.parseInt(getSize()));
	}

	public int getFieldOffset() {
		return fld.getOffset();
	}
	
	public boolean getAtomic() {
		return fld.isAtomic();
	}
	
}
