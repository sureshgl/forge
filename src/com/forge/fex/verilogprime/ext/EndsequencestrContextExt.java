package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndsequencestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndsequencestrContextExt extends AbstractBaseExt {

	public EndsequencestrContextExt(EndsequencestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndsequencestrContext getContext() {
		return (EndsequencestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endsequencestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndsequencestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndsequencestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}