package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BufstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BufstrContextExt extends AbstractBaseExt {

	public BufstrContextExt(BufstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BufstrContext getContext() {
		return (BufstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bufstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BufstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BufstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}