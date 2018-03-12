package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WorstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WorstrContextExt extends AbstractBaseExt {

	public WorstrContextExt(WorstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WorstrContext getContext() {
		return (WorstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).worstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WorstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WorstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}