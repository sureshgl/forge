package com.forge.parser.generator;

import java.io.File;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.common.FileUtils;
import com.forge.parser.RulesOfGrammarFile;

public class ContextClassGenerator {

	public static void main(String[] args) throws Exception {
		new ContextClassGenerator().generateClasses();
	}

	private void generateClasses() throws Exception {
		int count = 0;
		RulesOfGrammarFile rulesOfGrammarFile = new RulesOfGrammarFile("grammar/ForgeParser.g4");
		STGroupFile stgf = new STGroupFile("templates/forge/ClassContext.stg");
		for (String name : rulesOfGrammarFile.getParserRules()) {
			ST st = stgf.getInstanceOf("contextClassSkel");
			String classname = ContextClassGenerator.toContextCase(name);
			st.add("classname", classname);
			st.add("rulename", name);
			count++;
		}
		Map<String, String> altRules = rulesOfGrammarFile.getAltRules();
		for (String name : altRules.keySet()) {
			ST st = stgf.getInstanceOf("contextAltClassSkel");
			String classname = ContextClassGenerator.toContextCase(name);
			String parentClassName = ContextClassGenerator.toContextCase(altRules.get(name));
			st.add("classname", classname);
			st.add("parentClassName", parentClassName);
			st.add("rulename", altRules.get(name));
			count++;
			FileUtils.WriteFile(new File("src/com/forge/parser/ext/" + classname + "Ext.java"), st.render());
		}
		Set<String> parentRulesForAltRules = new HashSet<>(altRules.values());
		for (String name : parentRulesForAltRules) {
			ST st = stgf.getInstanceOf("contextAltParentClassSkel");
			String classname = ContextClassGenerator.toContextCase(name);
			st.add("classname", classname);
			count++;
			FileUtils.WriteFile(new File("src/com/forge/parser/ext/" + classname + "Ext.java"), st.render());
		}
		System.out.println("Generated " + count + " classes");
	}

	private static String toContextCase(String input) {
		StringBuilder sb = new StringBuilder();
		sb.append(input.substring(0, 1).toUpperCase());
		sb.append(input.substring(1));
		sb.append("Context");
		return sb.toString();
	}
}
