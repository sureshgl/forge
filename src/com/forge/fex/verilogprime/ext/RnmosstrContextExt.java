package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RnmosstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RnmosstrContextExt extends AbstractBaseExt {

	public RnmosstrContextExt(RnmosstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RnmosstrContext getContext() {
		return (RnmosstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rnmosstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RnmosstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RnmosstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}