package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OnestepstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OnestepstrContextExt extends AbstractBaseExt {

	public OnestepstrContextExt(OnestepstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OnestepstrContext getContext() {
		return (OnestepstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).onestepstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OnestepstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OnestepstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}