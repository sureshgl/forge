package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IntegerstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IntegerstrContextExt extends AbstractBaseExt {

	public IntegerstrContextExt(IntegerstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IntegerstrContext getContext() {
		return (IntegerstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).integerstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IntegerstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IntegerstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}