package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RefstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RefstrContextExt extends AbstractBaseExt {

	public RefstrContextExt(RefstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RefstrContext getContext() {
		return (RefstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).refstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RefstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RefstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}