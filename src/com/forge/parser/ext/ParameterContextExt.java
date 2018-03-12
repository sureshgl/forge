package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ParameterContext;

public class ParameterContextExt extends AbstractBaseExt {

	public ParameterContextExt(ParameterContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ParameterContext getContext() {
		return (ParameterContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ParameterContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ParameterContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
