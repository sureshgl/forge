package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Mintypmax_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Mintypmax_expressionContextExt extends AbstractBaseExt {

	public Mintypmax_expressionContextExt(Mintypmax_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Mintypmax_expressionContext getContext() {
		return (Mintypmax_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).mintypmax_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Mintypmax_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Mintypmax_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}