package com.forge.parser;

import java.util.List;

public interface SemanticValidator {
	public void duplicateNamesCheck(String parentName, List<String> blockNames);

	public void requiredPropertyCheck();

	public void arrayPropertyCheck();
}
