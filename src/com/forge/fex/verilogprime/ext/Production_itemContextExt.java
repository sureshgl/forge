package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Production_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Production_itemContextExt extends AbstractBaseExt {

	public Production_itemContextExt(Production_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Production_itemContext getContext() {
		return (Production_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).production_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Production_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Production_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}