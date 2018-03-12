package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assertion_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assertion_itemContextExt extends AbstractBaseExt {

	public Assertion_itemContextExt(Assertion_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assertion_itemContext getContext() {
		return (Assertion_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assertion_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assertion_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assertion_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}