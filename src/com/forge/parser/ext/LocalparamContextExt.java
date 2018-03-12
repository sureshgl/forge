package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.LocalparamContext;

public class LocalparamContextExt extends AbstractBaseExt {

	public LocalparamContextExt(LocalparamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LocalparamContext getContext() {
		return (LocalparamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).localparam());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LocalparamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LocalparamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
