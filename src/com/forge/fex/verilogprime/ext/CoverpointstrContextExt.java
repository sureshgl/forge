package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CoverpointstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CoverpointstrContextExt extends AbstractBaseExt {

	public CoverpointstrContextExt(CoverpointstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CoverpointstrContext getContext() {
		return (CoverpointstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverpointstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CoverpointstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CoverpointstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}