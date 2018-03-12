package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WaitstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WaitstrContextExt extends AbstractBaseExt {

	public WaitstrContextExt(WaitstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WaitstrContext getContext() {
		return (WaitstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).waitstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WaitstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WaitstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}