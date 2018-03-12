package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_item_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_item_expressionContextExt extends AbstractBaseExt {

	public Case_item_expressionContextExt(Case_item_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_item_expressionContext getContext() {
		return (Case_item_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_item_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_item_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Case_item_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}