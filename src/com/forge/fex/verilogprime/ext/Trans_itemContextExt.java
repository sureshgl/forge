package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Trans_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Trans_itemContextExt extends AbstractBaseExt {

	public Trans_itemContextExt(Trans_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Trans_itemContext getContext() {
		return (Trans_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trans_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Trans_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Trans_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}