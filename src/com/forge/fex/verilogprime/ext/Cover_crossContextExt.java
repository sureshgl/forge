package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cover_crossContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cover_crossContextExt extends AbstractBaseExt {

	public Cover_crossContextExt(Cover_crossContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cover_crossContext getContext() {
		return (Cover_crossContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cover_cross());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cover_crossContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Cover_crossContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}