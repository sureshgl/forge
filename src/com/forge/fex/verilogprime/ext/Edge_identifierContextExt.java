package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Edge_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Edge_identifierContextExt extends AbstractBaseExt {

	public Edge_identifierContextExt(Edge_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Edge_identifierContext getContext() {
		return (Edge_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).edge_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Edge_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Edge_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}