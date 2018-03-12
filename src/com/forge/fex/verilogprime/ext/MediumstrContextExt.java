package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.MediumstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class MediumstrContextExt extends AbstractBaseExt {

	public MediumstrContextExt(MediumstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MediumstrContext getContext() {
		return (MediumstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).mediumstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MediumstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MediumstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}