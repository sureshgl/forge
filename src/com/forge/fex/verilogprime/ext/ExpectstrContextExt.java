package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpectstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ExpectstrContextExt extends AbstractBaseExt {

	public ExpectstrContextExt(ExpectstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ExpectstrContext getContext() {
		return (ExpectstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).expectstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ExpectstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ExpectstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}