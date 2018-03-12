package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BinsstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BinsstrContextExt extends AbstractBaseExt {

	public BinsstrContextExt(BinsstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BinsstrContext getContext() {
		return (BinsstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).binsstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BinsstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BinsstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}