package com.forge.runner;

import java.util.ArrayList;
import java.util.List;

import com.forge.parser.gen.ForgeParser.StartContext;

public class SemanticChecks {
	public void run(StartContext startContext) {
		startContext.extendedContext.requiredPropertyCheck();
		String parentName = null;
		List<String> blockNames = new ArrayList<>();
		startContext.extendedContext.duplicateNamesCheck(parentName, blockNames);
		startContext.extendedContext.arrayPropertyCheck();
	}
}
