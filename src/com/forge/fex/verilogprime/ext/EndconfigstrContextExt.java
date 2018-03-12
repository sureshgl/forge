package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndconfigstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndconfigstrContextExt extends AbstractBaseExt {

	public EndconfigstrContextExt(EndconfigstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndconfigstrContext getContext() {
		return (EndconfigstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endconfigstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndconfigstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndconfigstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}