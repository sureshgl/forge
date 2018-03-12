package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LargestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LargestrContextExt extends AbstractBaseExt {

	public LargestrContextExt(LargestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LargestrContext getContext() {
		return (LargestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).largestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LargestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LargestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}