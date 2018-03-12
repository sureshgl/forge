package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SolvestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SolvestrContextExt extends AbstractBaseExt {

	public SolvestrContextExt(SolvestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SolvestrContext getContext() {
		return (SolvestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).solvestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SolvestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SolvestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}