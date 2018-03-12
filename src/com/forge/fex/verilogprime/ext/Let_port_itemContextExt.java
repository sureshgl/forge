package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_port_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_port_itemContextExt extends AbstractBaseExt {

	public Let_port_itemContextExt(Let_port_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_port_itemContext getContext() {
		return (Let_port_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_port_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_port_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Let_port_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}