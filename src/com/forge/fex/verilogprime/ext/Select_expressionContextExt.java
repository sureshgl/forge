package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Select_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Select_expressionContextExt extends AbstractBaseExt {

	public Select_expressionContextExt(Select_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Select_expressionContext getContext() {
		return (Select_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).select_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Select_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Select_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}