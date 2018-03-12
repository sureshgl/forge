package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Start_edge_offsetContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Start_edge_offsetContextExt extends AbstractBaseExt {

	public Start_edge_offsetContextExt(Start_edge_offsetContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Start_edge_offsetContext getContext() {
		return (Start_edge_offsetContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).start_edge_offset());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Start_edge_offsetContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Start_edge_offsetContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}