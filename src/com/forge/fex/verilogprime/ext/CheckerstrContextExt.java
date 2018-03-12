package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CheckerstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CheckerstrContextExt extends AbstractBaseExt {

	public CheckerstrContextExt(CheckerstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CheckerstrContext getContext() {
		return (CheckerstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checkerstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CheckerstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CheckerstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}