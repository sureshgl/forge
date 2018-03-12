package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constraint_block_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constraint_block_itemContextExt extends AbstractBaseExt {

	public Constraint_block_itemContextExt(Constraint_block_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constraint_block_itemContext getContext() {
		return (Constraint_block_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constraint_block_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constraint_block_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constraint_block_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}