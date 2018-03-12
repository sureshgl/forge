package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Edge_descriptorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Edge_descriptorContextExt extends AbstractBaseExt {

	public Edge_descriptorContextExt(Edge_descriptorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Edge_descriptorContext getContext() {
		return (Edge_descriptorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).edge_descriptor());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Edge_descriptorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Edge_descriptorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}