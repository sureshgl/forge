package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.SizeContext;

public class SizeContextExt extends AbstractBaseExt {

	public SizeContextExt(SizeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SizeContext getContext() {
		return (SizeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).size());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SizeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SizeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
