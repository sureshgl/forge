package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ignore_binsstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ignore_binsstrContextExt extends AbstractBaseExt {

	public Ignore_binsstrContextExt(Ignore_binsstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ignore_binsstrContext getContext() {
		return (Ignore_binsstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ignore_binsstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ignore_binsstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ignore_binsstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}