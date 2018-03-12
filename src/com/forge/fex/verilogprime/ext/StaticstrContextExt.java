package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StaticstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StaticstrContextExt extends AbstractBaseExt {

	public StaticstrContextExt(StaticstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StaticstrContext getContext() {
		return (StaticstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).staticstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StaticstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StaticstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}