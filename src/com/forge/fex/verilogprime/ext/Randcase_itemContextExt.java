package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Randcase_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Randcase_itemContextExt extends AbstractBaseExt {

	public Randcase_itemContextExt(Randcase_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Randcase_itemContext getContext() {
		return (Randcase_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randcase_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Randcase_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Randcase_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}