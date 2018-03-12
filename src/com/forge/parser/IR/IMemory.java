package com.forge.parser.IR;

import java.util.List;

import org.stringtemplate.v4.ST;

import com.forge.runner.ForgeRunnerSession;

public interface IMemory {

	public String getName();

	public List<IField> getFields();

	public Integer getMemoryOffset();

	public boolean hasInterfaceOnly();

	public Integer getWords();

	public Integer getLogOfWords();

	public Integer getEccWidth();

	public Integer getReadPortValue();

	public Integer getWritePortValue();

	public Boolean getIsReadMultiport();

	public Boolean getIsWriteMultiport();

	public Integer getBits();

	public Integer getRnaxiWords();

	public Integer getRnaxiWordsWidth();

	public Integer getTotalSize();

	public String getStartOffset();

	public String getEndOffset();

	public Integer getTotalSizeInWords();

	public String getEndOffset(int index);

	public Integer getArraySize();

	public Integer getSizeInWords();

	public String getStartOffset(int index);

	public ST getVHeaderFieldStructureST();

	public List<ST> getVHeaderMemoryStructureST(ForgeRunnerSession forgeRunnerSession);

	public ST getVHeaderMemory(ForgeRunnerSession forgeRunnerSession);

	public Integer getBitsInWords();

	public String getPortCap();

	public String getMemogenCmdLine();

}
