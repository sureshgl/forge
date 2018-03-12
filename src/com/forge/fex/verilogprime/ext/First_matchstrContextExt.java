package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.First_matchstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class First_matchstrContextExt extends AbstractBaseExt {

	public First_matchstrContextExt(First_matchstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public First_matchstrContext getContext() {
		return (First_matchstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).first_matchstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof First_matchstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ First_matchstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}