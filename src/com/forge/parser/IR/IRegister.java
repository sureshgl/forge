package com.forge.parser.IR;

import java.util.List;

import org.stringtemplate.v4.ST;

import com.forge.runner.ForgeRunnerSession;

public interface IRegister {

	public List<IField> getFields();

	public String getName();

	public Integer getArraySize();

	public List<Integer> getArray();

	public Integer getTotalSize();

	public Integer getRegisterOffset();

	public Integer getNumberofBeats();

	public Integer getRnaxiWords();

	public Integer getRnaxiWordsWidth();

	public Integer getRegisterWordWidth();

	public String getReadMask();

	public String getWriteMask();

	public ST getVHeaderRegister(ForgeRunnerSession forgeRunnerSession);

	public List<ST> getVHeaderRegisterStructureST(ForgeRunnerSession forgeRunnerSession);

	public String getStartOffset();

	public String getEndOffset();

	public ST getVHeaderFieldStructureST(Integer registerInstance);

	public Integer getTotalSizeInWords();

	public String getStartOffset(int index);

	public String getEndOffset(int index);

	public Integer getSizeInWords();
}
