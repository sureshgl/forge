package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Min_sizeContext;

public class Min_sizeContextExt extends AbstractBaseExt {

	public Min_sizeContextExt(Min_sizeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Min_sizeContext getContext() {
		return (Min_sizeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).min_size());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Min_sizeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Min_sizeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
