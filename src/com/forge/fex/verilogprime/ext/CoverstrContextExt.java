package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CoverstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CoverstrContextExt extends AbstractBaseExt {

	public CoverstrContextExt(CoverstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CoverstrContext getContext() {
		return (CoverstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CoverstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CoverstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}