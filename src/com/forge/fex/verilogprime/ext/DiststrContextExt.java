package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DiststrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DiststrContextExt extends AbstractBaseExt {

	public DiststrContextExt(DiststrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DiststrContext getContext() {
		return (DiststrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).diststr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DiststrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DiststrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}