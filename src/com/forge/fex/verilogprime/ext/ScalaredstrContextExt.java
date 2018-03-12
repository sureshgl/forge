package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ScalaredstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ScalaredstrContextExt extends AbstractBaseExt {

	public ScalaredstrContextExt(ScalaredstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ScalaredstrContext getContext() {
		return (ScalaredstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).scalaredstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ScalaredstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ScalaredstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}