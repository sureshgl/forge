package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ErrorContext;

public class ErrorContextExt extends AbstractBaseExt {

	public ErrorContextExt(ErrorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ErrorContext getContext() {
		return (ErrorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).error());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ErrorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ErrorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
