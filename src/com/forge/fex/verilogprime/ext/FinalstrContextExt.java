package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.FinalstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class FinalstrContextExt extends AbstractBaseExt {

	public FinalstrContextExt(FinalstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public FinalstrContext getContext() {
		return (FinalstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).finalstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof FinalstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + FinalstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}