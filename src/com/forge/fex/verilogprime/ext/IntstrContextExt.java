package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IntstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IntstrContextExt extends AbstractBaseExt {

	public IntstrContextExt(IntstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IntstrContext getContext() {
		return (IntstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).intstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IntstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IntstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}