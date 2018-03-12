package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WithstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WithstrContextExt extends AbstractBaseExt {

	public WithstrContextExt(WithstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WithstrContext getContext() {
		return (WithstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).withstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WithstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WithstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}