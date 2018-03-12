package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndcasestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndcasestrContextExt extends AbstractBaseExt {

	public EndcasestrContextExt(EndcasestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndcasestrContext getContext() {
		return (EndcasestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endcasestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndcasestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndcasestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}