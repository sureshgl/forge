package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WhilestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WhilestrContextExt extends AbstractBaseExt {

	public WhilestrContextExt(WhilestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WhilestrContext getContext() {
		return (WhilestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).whilestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WhilestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WhilestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}