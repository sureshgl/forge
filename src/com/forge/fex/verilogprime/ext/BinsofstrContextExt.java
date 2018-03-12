package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BinsofstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BinsofstrContextExt extends AbstractBaseExt {

	public BinsofstrContextExt(BinsofstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BinsofstrContext getContext() {
		return (BinsofstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).binsofstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BinsofstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BinsofstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}