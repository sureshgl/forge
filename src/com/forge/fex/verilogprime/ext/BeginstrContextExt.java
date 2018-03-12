package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BeginstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BeginstrContextExt extends AbstractBaseExt {

	public BeginstrContextExt(BeginstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BeginstrContext getContext() {
		return (BeginstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).beginstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BeginstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BeginstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}