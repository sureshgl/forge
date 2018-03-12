package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Const_or_range_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Const_or_range_expressionContextExt extends AbstractBaseExt {

	public Const_or_range_expressionContextExt(Const_or_range_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Const_or_range_expressionContext getContext() {
		return (Const_or_range_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).const_or_range_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Const_or_range_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Const_or_range_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}