package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AliasstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AliasstrContextExt extends AbstractBaseExt {

	public AliasstrContextExt(AliasstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AliasstrContext getContext() {
		return (AliasstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).aliasstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AliasstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AliasstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}