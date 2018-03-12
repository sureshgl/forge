package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RandsequencestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RandsequencestrContextExt extends AbstractBaseExt {

	public RandsequencestrContextExt(RandsequencestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RandsequencestrContext getContext() {
		return (RandsequencestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randsequencestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RandsequencestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ RandsequencestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}