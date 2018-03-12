package com.forge.parser;

import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.gen.ForgeLexer;
import com.forge.parser.gen.ForgeParser;
import com.forge.parser.gen.ForgeParser.NumberContext;

public class IntValueOfNumberInForgeTest {
	private static final Map<String, String> ExpActMap = new HashMap<>();
	private static final Map<String,String> symbolTable = new HashMap<>();


	static {
		IntValueOfNumberInForgeTest.ExpActMap.put("PA'hAF", "15");
		IntValueOfNumberInForgeTest.ExpActMap.put("PB'hAF", "175");
		IntValueOfNumberInForgeTest.ExpActMap.put("PC'hAF", "175");
		IntValueOfNumberInForgeTest.ExpActMap.put("PA'o54", "12");
		IntValueOfNumberInForgeTest.ExpActMap.put("PB'o75", "61");
		IntValueOfNumberInForgeTest.ExpActMap.put("PD'o75", "61");
		IntValueOfNumberInForgeTest.ExpActMap.put("4'd12", "12");
		IntValueOfNumberInForgeTest.ExpActMap.put("8'd12", "12");
		IntValueOfNumberInForgeTest.ExpActMap.put("'d12", "12");
		IntValueOfNumberInForgeTest.ExpActMap.put("2'd12", "0");
		IntValueOfNumberInForgeTest.ExpActMap.put("4'b1010011", "3");
		IntValueOfNumberInForgeTest.ExpActMap.put("2'b10", "2");
		IntValueOfNumberInForgeTest.ExpActMap.put("7'b10", "2");
		IntValueOfNumberInForgeTest.ExpActMap.put("5.5", "5.5");
		
		IntValueOfNumberInForgeTest.symbolTable.put("PA", "4");
		IntValueOfNumberInForgeTest.symbolTable.put("PB", "16");
		IntValueOfNumberInForgeTest.symbolTable.put("PC", "8");
		IntValueOfNumberInForgeTest.symbolTable.put("PD", "6");
	}

	@Test
	public void IntValueOfNumberInForge() throws Exception {
		for(String key : IntValueOfNumberInForgeTest.ExpActMap.keySet()){
			ForgeLexer lexer = new ForgeLexer(new ANTLRInputStream(key));
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			ForgeParser parser = new ForgeParser(tokens);
			NumberContext ctx = (NumberContext)new PopulateExtendedContextVisitor().visit(parser.number());
			if(ctx.extendedContext.intValue(IntValueOfNumberInForgeTest.symbolTable).equals(IntValueOfNumberInForgeTest.ExpActMap.get(key))){
				Assert.assertTrue(true);
			} else {
				Assert.fail();
			}
		}
	}

}
