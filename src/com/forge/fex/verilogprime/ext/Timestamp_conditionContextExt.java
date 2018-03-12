package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Timestamp_conditionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Timestamp_conditionContextExt extends AbstractBaseExt {

	public Timestamp_conditionContextExt(Timestamp_conditionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Timestamp_conditionContext getContext() {
		return (Timestamp_conditionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timestamp_condition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Timestamp_conditionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Timestamp_conditionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}