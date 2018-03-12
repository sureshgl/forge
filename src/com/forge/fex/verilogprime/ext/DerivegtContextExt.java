package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DerivegtContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DerivegtContextExt extends AbstractBaseExt {

	public DerivegtContextExt(DerivegtContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DerivegtContext getContext() {
		return (DerivegtContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).derivegt());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DerivegtContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DerivegtContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}