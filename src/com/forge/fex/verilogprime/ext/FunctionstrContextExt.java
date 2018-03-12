package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.FunctionstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class FunctionstrContextExt extends AbstractBaseExt {

	public FunctionstrContextExt(FunctionstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public FunctionstrContext getContext() {
		return (FunctionstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).functionstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof FunctionstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + FunctionstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}