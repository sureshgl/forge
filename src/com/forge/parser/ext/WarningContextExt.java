package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.WarningContext;

public class WarningContextExt extends AbstractBaseExt {

	public WarningContextExt(WarningContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WarningContext getContext() {
		return (WarningContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).warning());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WarningContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WarningContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
