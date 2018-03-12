package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LparenContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LparenContextExt extends AbstractBaseExt {

	public LparenContextExt(LparenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LparenContext getContext() {
		return (LparenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lparen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LparenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LparenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}