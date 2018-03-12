package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RtranstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RtranstrContextExt extends AbstractBaseExt {

	public RtranstrContextExt(RtranstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RtranstrContext getContext() {
		return (RtranstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rtranstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RtranstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RtranstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}