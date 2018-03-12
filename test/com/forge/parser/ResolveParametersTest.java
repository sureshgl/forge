package com.forge.parser;

import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;
import org.junit.Test;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Source_textContext;
import com.forge.fex.verilogprime.runner.ModuleParser;
import com.forge.fex.verilogprime.utils.ModuleIndexer;

public class ResolveParametersTest {
	
	@Test
	public void ResolveParameters(){
		File f = new File("./resources/pifo/rtl/pifo.v");
		ModuleIndexer mi = new ModuleIndexer(Arrays.asList(f.toPath()));
		ModuleParser mp = new ModuleParser(mi);
		Source_textContext ctx = (Source_textContext) new com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor().visit(mp.getModule("pifo"));
		Map<String, ParserRuleContext> parameterMap = new HashMap<String,ParserRuleContext>();
		ctx.extendedContext.populateParametersForForgeEvaluation(parameterMap);
		Map<String,String> symbols  = ForgeUtils.evaluateParameters(parameterMap);
		System.out.println(symbols);
	}
}
