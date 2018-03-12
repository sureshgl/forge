package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_blockContextExt extends AbstractBaseExt {

	public Constraint_blockContextExt(Constraint_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_blockContext getContext() {
		return (Constraint_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}