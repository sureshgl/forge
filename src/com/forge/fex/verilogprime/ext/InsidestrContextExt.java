package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.InsidestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class InsidestrContextExt extends AbstractBaseExt {

	public InsidestrContextExt(InsidestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InsidestrContext getContext() {
		return (InsidestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).insidestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InsidestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InsidestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}