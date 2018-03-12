package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ContinuestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ContinuestrContextExt extends AbstractBaseExt {

	public ContinuestrContextExt(ContinuestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ContinuestrContext getContext() {
		return (ContinuestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).continuestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ContinuestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ContinuestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}