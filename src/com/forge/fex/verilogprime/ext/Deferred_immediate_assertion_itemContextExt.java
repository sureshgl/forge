package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Deferred_immediate_assertion_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Deferred_immediate_assertion_itemContextExt extends AbstractBaseExt {

	public Deferred_immediate_assertion_itemContextExt(Deferred_immediate_assertion_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Deferred_immediate_assertion_itemContext getContext() {
		return (Deferred_immediate_assertion_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).deferred_immediate_assertion_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Deferred_immediate_assertion_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Deferred_immediate_assertion_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}