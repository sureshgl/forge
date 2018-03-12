package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UniquestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UniquestrContextExt extends AbstractBaseExt {

	public UniquestrContextExt(UniquestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UniquestrContext getContext() {
		return (UniquestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).uniquestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UniquestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UniquestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}