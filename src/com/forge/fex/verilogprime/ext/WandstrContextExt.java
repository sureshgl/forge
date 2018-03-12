package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WandstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WandstrContextExt extends AbstractBaseExt {

	public WandstrContextExt(WandstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WandstrContext getContext() {
		return (WandstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wandstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WandstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WandstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}