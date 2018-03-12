package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_itemContextExt extends AbstractBaseExt {

	public Case_itemContextExt(Case_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_itemContext getContext() {
		return (Case_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Case_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}