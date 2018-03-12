package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WildcardstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WildcardstrContextExt extends AbstractBaseExt {

	public WildcardstrContextExt(WildcardstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WildcardstrContext getContext() {
		return (WildcardstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wildcardstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WildcardstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WildcardstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}