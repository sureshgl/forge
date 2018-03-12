package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DisablestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DisablestrContextExt extends AbstractBaseExt {

	public DisablestrContextExt(DisablestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DisablestrContext getContext() {
		return (DisablestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).disablestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DisablestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DisablestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}