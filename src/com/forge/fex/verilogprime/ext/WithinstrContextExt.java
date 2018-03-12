package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WithinstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WithinstrContextExt extends AbstractBaseExt {

	public WithinstrContextExt(WithinstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WithinstrContext getContext() {
		return (WithinstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).withinstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WithinstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WithinstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}