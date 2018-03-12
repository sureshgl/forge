package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Specify_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Specify_itemContextExt extends AbstractBaseExt {

	public Specify_itemContextExt(Specify_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Specify_itemContext getContext() {
		return (Specify_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).specify_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Specify_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Specify_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}