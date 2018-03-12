package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.DebugContext;

public class DebugContextExt extends AbstractBaseExt {

	public DebugContextExt(DebugContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DebugContext getContext() {
		return (DebugContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).debug());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DebugContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DebugContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
