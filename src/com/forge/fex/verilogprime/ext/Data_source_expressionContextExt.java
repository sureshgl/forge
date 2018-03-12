package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_source_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Data_source_expressionContextExt extends AbstractBaseExt {

	public Data_source_expressionContextExt(Data_source_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_source_expressionContext getContext() {
		return (Data_source_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_source_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_source_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Data_source_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}