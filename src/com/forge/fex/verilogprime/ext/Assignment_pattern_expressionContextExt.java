package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_pattern_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_pattern_expressionContextExt extends AbstractBaseExt {

	public Assignment_pattern_expressionContextExt(Assignment_pattern_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_pattern_expressionContext getContext() {
		return (Assignment_pattern_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_pattern_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_pattern_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_pattern_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}