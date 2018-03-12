package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.FatalContext;

public class FatalContextExt extends AbstractBaseExt {

	public FatalContextExt(FatalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public FatalContext getContext() {
		return (FatalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).fatal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof FatalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + FatalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
