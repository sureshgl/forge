package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PrContext;

public class PrContextExt extends AbstractBaseExt {

	public PrContextExt(PrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PrContext getContext() {
		return (PrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
