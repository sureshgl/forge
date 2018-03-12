package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Timecheck_conditionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Timecheck_conditionContextExt extends AbstractBaseExt {

	public Timecheck_conditionContextExt(Timecheck_conditionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Timecheck_conditionContext getContext() {
		return (Timecheck_conditionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timecheck_condition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Timecheck_conditionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Timecheck_conditionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}