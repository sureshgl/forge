package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.MinusequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class MinusequalsContextExt extends AbstractBaseExt {

	public MinusequalsContextExt(MinusequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MinusequalsContext getContext() {
		return (MinusequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).minusequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MinusequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MinusequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}