package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ExpressionContext;
import com.forge.parser.gen.ForgeParser.Subtraction_expressionContext;

public class Subtraction_expressionContextExt extends ExpressionContextExt {

	public Subtraction_expressionContextExt(Subtraction_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ExpressionContext getContext() {
		return (ExpressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ExpressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Subtraction_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
