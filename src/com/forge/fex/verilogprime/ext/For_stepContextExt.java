package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.For_stepContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class For_stepContextExt extends AbstractBaseExt {

	public For_stepContextExt(For_stepContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public For_stepContext getContext() {
		return (For_stepContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).for_step());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof For_stepContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + For_stepContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}