package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ContextstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ContextstrContextExt extends AbstractBaseExt {

	public ContextstrContextExt(ContextstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ContextstrContext getContext() {
		return (ContextstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).contextstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ContextstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ContextstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}