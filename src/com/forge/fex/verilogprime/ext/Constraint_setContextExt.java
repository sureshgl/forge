package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_setContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_setContextExt extends AbstractBaseExt {

	public Constraint_setContextExt(Constraint_setContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_setContext getContext() {
		return (Constraint_setContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_set());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_setContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_setContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}