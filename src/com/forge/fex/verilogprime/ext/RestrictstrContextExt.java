package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RestrictstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RestrictstrContextExt extends AbstractBaseExt {

	public RestrictstrContextExt(RestrictstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RestrictstrContext getContext() {
		return (RestrictstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).restrictstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RestrictstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RestrictstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}