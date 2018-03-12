package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TriorstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TriorstrContextExt extends AbstractBaseExt {

	public TriorstrContextExt(TriorstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TriorstrContext getContext() {
		return (TriorstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).triorstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TriorstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TriorstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}