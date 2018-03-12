package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndspecifystrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndspecifystrContextExt extends AbstractBaseExt {

	public EndspecifystrContextExt(EndspecifystrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndspecifystrContext getContext() {
		return (EndspecifystrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endspecifystr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndspecifystrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndspecifystrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}