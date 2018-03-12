package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DostrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DostrContextExt extends AbstractBaseExt {

	public DostrContextExt(DostrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DostrContext getContext() {
		return (DostrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dostr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DostrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DostrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}