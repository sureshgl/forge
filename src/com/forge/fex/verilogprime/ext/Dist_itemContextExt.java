package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dist_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dist_itemContextExt extends AbstractBaseExt {

	public Dist_itemContextExt(Dist_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dist_itemContext getContext() {
		return (Dist_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dist_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dist_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Dist_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}