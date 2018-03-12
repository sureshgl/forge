package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndpackagestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndpackagestrContextExt extends AbstractBaseExt {

	public EndpackagestrContextExt(EndpackagestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndpackagestrContext getContext() {
		return (EndpackagestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endpackagestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndpackagestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndpackagestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}