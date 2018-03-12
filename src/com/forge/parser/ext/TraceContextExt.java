package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.TraceContext;

public class TraceContextExt extends AbstractBaseExt {

	public TraceContextExt(TraceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TraceContext getContext() {
		return (TraceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trace());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TraceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TraceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
