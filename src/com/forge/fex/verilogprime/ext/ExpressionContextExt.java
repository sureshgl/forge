package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ExpressionContextExt extends AbstractBaseExt {

	public ExpressionContextExt(ExpressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ExpressionContext getContext() {
		return (ExpressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ExpressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ExpressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}