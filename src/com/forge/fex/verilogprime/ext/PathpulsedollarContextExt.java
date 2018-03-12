package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PathpulsedollarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PathpulsedollarContextExt extends AbstractBaseExt {

	public PathpulsedollarContextExt(PathpulsedollarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PathpulsedollarContext getContext() {
		return (PathpulsedollarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pathpulsedollar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PathpulsedollarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ PathpulsedollarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}