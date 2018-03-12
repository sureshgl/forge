package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RegstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RegstrContextExt extends AbstractBaseExt {

	public RegstrContextExt(RegstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RegstrContext getContext() {
		return (RegstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).regstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RegstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RegstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}