package com.forge.parser.IR;

import java.util.List;

public interface IField {

	public String getName();

	public Integer getSize();

	List<IField> getFields();

	public Integer getOffset();
	
	public String getStartOffset();

	public String getEndOffset();

	public String getRstValue();

	public String getRange();
	
	public Integer getAlign();

	public String getRangeInDecimal();
	
	public String getDes();
	
	
	
	public boolean hasIncrementAttribute();

	public boolean hasInterfaceOnly();

	public boolean hasWriteAttribute();

	public boolean hasReadAttribute();
	
	public boolean hasTypeAttribute();
	
	

	public boolean isReadTrigger();

	public boolean isWriteTrigger();

	public boolean isReadClear();

	public boolean isReadOnly();

	public boolean isWriteOnly();

	public boolean isReadWrite();

	public boolean isTypeStatus();

	public boolean isTypeConfig();

	public boolean isTypeCounter();

	public boolean isTypeSatCounter();
	
	public boolean isAtomic();

}
