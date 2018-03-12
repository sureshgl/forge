package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DeassignstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DeassignstrContextExt extends AbstractBaseExt {

	public DeassignstrContextExt(DeassignstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DeassignstrContext getContext() {
		return (DeassignstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).deassignstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DeassignstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DeassignstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}