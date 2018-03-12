package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SmallstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SmallstrContextExt extends AbstractBaseExt {

	public SmallstrContextExt(SmallstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SmallstrContext getContext() {
		return (SmallstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).smallstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SmallstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SmallstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}