package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndgeneratestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndgeneratestrContextExt extends AbstractBaseExt {

	public EndgeneratestrContextExt(EndgeneratestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndgeneratestrContext getContext() {
		return (EndgeneratestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endgeneratestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndgeneratestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndgeneratestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}