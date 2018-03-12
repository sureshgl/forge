package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StarContextExt extends AbstractBaseExt {

	public StarContextExt(StarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StarContext getContext() {
		return (StarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).star());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}