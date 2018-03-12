package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TriregstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TriregstrContextExt extends AbstractBaseExt {

	public TriregstrContextExt(TriregstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TriregstrContext getContext() {
		return (TriregstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).triregstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TriregstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TriregstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}