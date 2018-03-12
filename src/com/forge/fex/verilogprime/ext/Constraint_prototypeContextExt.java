package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_prototypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_prototypeContextExt extends AbstractBaseExt {

	public Constraint_prototypeContextExt(Constraint_prototypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_prototypeContext getContext() {
		return (Constraint_prototypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_prototype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_prototypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_prototypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}