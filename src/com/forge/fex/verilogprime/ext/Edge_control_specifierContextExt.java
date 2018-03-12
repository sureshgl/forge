package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Edge_control_specifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Edge_control_specifierContextExt extends AbstractBaseExt {

	public Edge_control_specifierContextExt(Edge_control_specifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Edge_control_specifierContext getContext() {
		return (Edge_control_specifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).edge_control_specifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Edge_control_specifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Edge_control_specifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}