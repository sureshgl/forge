package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RpmosstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RpmosstrContextExt extends AbstractBaseExt {

	public RpmosstrContextExt(RpmosstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RpmosstrContext getContext() {
		return (RpmosstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rpmosstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RpmosstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RpmosstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}