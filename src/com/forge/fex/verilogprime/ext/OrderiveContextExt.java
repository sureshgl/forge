package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OrderiveContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OrderiveContextExt extends AbstractBaseExt {

	public OrderiveContextExt(OrderiveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OrderiveContext getContext() {
		return (OrderiveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).orderive());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OrderiveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OrderiveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}