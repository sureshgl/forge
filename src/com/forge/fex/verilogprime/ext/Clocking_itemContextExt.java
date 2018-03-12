package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_itemContextExt extends AbstractBaseExt {

	public Clocking_itemContextExt(Clocking_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_itemContext getContext() {
		return (Clocking_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Clocking_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}