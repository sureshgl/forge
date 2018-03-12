package com.forge.parser.data;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.codehaus.jackson.annotate.JsonIgnore;

import com.forge.parser.IR.IRegister;

public class RegInstance {

	@JsonIgnore
	private IRegister reg;
	private int instanceNumber;

	private List<Field> fields;

	public RegInstance(IRegister reg, int i, List<Field> fields) {
		this.reg = reg;
		this.instanceNumber = i;
		this.fields = fields;
		calculateFieldAcc();
	}

	private void calculateFieldAcc() {
		AtomicInteger accSize = new AtomicInteger(0);
		for (Field field : fields) {
			field.calculateFieldAcc(accSize);
		}
	}

	public Integer getInstanceNumber() {
		return instanceNumber;
	}

	public Integer getRegisterWordWidth() {
		Integer numberOfBeats = Integer.parseInt(getNumberofBeats());
		return (numberOfBeats + 1) * 32;
	}

	public Integer getTotalSize() {
		return reg.getTotalSize();
	}

	public Integer getLeftWordsWidth() {
		return getRegisterWordWidth() - 1 - (getTotalSize() - 1);
	}

	public String getRnaxiWords() {
		return reg.getRnaxiWords().toString();
	}

	public String getRnaxiWordsRange() {
		return "(" + reg.getRnaxiWords() + "-1)";
	}

	public String getStartOffset() {
		return reg.getStartOffset(instanceNumber);
	}

	public String getEndOffset() {
		return reg.getEndOffset(instanceNumber);
	}

	public String getName() {
		return reg.getName() + "_" + instanceNumber;
	}

	public List<Field> getFields() {
		return fields;
	}

	public String getNumberofBeats() {
		return reg.getNumberofBeats().toString();
	}
}
