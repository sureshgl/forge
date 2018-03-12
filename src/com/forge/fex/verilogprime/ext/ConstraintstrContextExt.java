package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ConstraintstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ConstraintstrContextExt extends AbstractBaseExt {

	public ConstraintstrContextExt(ConstraintstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ConstraintstrContext getContext() {
		return (ConstraintstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraintstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ConstraintstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ConstraintstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}