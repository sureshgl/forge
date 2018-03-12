package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Select_conditionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Select_conditionContextExt extends AbstractBaseExt {

	public Select_conditionContextExt(Select_conditionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Select_conditionContext getContext() {
		return (Select_conditionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).select_condition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Select_conditionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Select_conditionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}