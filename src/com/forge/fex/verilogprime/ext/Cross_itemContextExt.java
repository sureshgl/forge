package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cross_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cross_itemContextExt extends AbstractBaseExt {

	public Cross_itemContextExt(Cross_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cross_itemContext getContext() {
		return (Cross_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cross_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cross_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Cross_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}