package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_range_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_range_expressionContextExt extends AbstractBaseExt {

	public Constant_range_expressionContextExt(Constant_range_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_range_expressionContext getContext() {
		return (Constant_range_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_range_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_range_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_range_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}