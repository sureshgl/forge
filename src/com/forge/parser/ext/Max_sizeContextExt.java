package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Max_sizeContext;

public class Max_sizeContextExt extends AbstractBaseExt {

	public Max_sizeContextExt(Max_sizeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Max_sizeContext getContext() {
		return (Max_sizeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).max_size());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Max_sizeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Max_sizeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
