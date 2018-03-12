package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_actual_argContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_actual_argContextExt extends AbstractBaseExt {

	public Let_actual_argContextExt(Let_actual_argContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_actual_argContext getContext() {
		return (Let_actual_argContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_actual_arg());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_actual_argContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Let_actual_argContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}