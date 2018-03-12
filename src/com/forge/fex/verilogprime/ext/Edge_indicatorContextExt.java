package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Edge_indicatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Edge_indicatorContextExt extends AbstractBaseExt {

	public Edge_indicatorContextExt(Edge_indicatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Edge_indicatorContext getContext() {
		return (Edge_indicatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).edge_indicator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Edge_indicatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Edge_indicatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}