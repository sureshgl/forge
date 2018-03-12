package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.GlobalstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class GlobalstrContextExt extends AbstractBaseExt {

	public GlobalstrContextExt(GlobalstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public GlobalstrContext getContext() {
		return (GlobalstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).globalstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof GlobalstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + GlobalstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}