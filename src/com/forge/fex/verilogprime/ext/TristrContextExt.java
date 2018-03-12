package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TristrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TristrContextExt extends AbstractBaseExt {

	public TristrContextExt(TristrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TristrContext getContext() {
		return (TristrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tristr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TristrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TristrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}