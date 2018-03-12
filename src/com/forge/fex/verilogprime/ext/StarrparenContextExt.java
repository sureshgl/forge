package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StarrparenContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StarrparenContextExt extends AbstractBaseExt {

	public StarrparenContextExt(StarrparenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StarrparenContext getContext() {
		return (StarrparenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).starrparen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StarrparenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StarrparenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}