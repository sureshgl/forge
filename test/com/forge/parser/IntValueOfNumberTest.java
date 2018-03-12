package com.forge.parser;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.Assert;
import org.junit.Test;

import com.forge.common.Utils.Pair;
import com.forge.fex.verilogprime.gen.VerilogPrimeLexer;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NumberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.data.RegInstance;
import com.forge.parser.data.Register;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class IntValueOfNumberTest {

	private static final Map<String, String> ExpActMap = new HashMap<>();


	static {
		IntValueOfNumberTest.ExpActMap.put("4'hAF", "15");
		IntValueOfNumberTest.ExpActMap.put("16'hAF", "175");
		IntValueOfNumberTest.ExpActMap.put("8'hAF", "175");
		IntValueOfNumberTest.ExpActMap.put("4'o54", "12");
		IntValueOfNumberTest.ExpActMap.put("16'o75", "61");
		IntValueOfNumberTest.ExpActMap.put("6'o75", "61");
		IntValueOfNumberTest.ExpActMap.put("4'd12", "12");
		IntValueOfNumberTest.ExpActMap.put("8'd12", "12");
		IntValueOfNumberTest.ExpActMap.put("'d12", "12");
		IntValueOfNumberTest.ExpActMap.put("2'd12", "0");
		IntValueOfNumberTest.ExpActMap.put("4'b1010011", "3");
		IntValueOfNumberTest.ExpActMap.put("2'b10", "2");
		IntValueOfNumberTest.ExpActMap.put("7'b10", "2");
		IntValueOfNumberTest.ExpActMap.put("5.5", "5.5");
	}

	@Test
	public void IntValueOfNumber() throws Exception {
		for(String key : IntValueOfNumberTest.ExpActMap.keySet()){
			VerilogPrimeLexer lexer = new VerilogPrimeLexer(new ANTLRInputStream(key));
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			VerilogPrimeParser parser = new VerilogPrimeParser(tokens);
			NumberContext ctx = (NumberContext)new PopulateExtendedContextVisitor().visit(parser.number());
			if(ctx.extendedContext.intValue().equals(IntValueOfNumberTest.ExpActMap.get(key))){
				Assert.assertTrue(true);
			} else {
				Assert.fail();
			}
		}
	}

}
