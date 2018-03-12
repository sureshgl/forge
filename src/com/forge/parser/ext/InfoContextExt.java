package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.InfoContext;

public class InfoContextExt extends AbstractBaseExt {

	public InfoContextExt(InfoContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InfoContext getContext() {
		return (InfoContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).info());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InfoContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InfoContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
