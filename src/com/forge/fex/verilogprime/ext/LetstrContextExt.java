package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LetstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LetstrContextExt extends AbstractBaseExt {

	public LetstrContextExt(LetstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LetstrContext getContext() {
		return (LetstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).letstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LetstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LetstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}