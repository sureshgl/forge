package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.End_edge_offsetContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class End_edge_offsetContextExt extends AbstractBaseExt {

	public End_edge_offsetContextExt(End_edge_offsetContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public End_edge_offsetContext getContext() {
		return (End_edge_offsetContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).end_edge_offset());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof End_edge_offsetContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ End_edge_offsetContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}