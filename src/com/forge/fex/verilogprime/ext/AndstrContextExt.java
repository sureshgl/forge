package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AndstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AndstrContextExt extends AbstractBaseExt {

	public AndstrContextExt(AndstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AndstrContext getContext() {
		return (AndstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).andstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AndstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AndstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}