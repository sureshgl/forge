package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DeriveContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DeriveContextExt extends AbstractBaseExt {

	public DeriveContextExt(DeriveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DeriveContext getContext() {
		return (DeriveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).derive());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DeriveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DeriveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}