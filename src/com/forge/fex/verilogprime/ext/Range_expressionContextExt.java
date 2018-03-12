package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Range_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Range_expressionContextExt extends AbstractBaseExt {

	public Range_expressionContextExt(Range_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Range_expressionContext getContext() {
		return (Range_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).range_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Range_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Range_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}