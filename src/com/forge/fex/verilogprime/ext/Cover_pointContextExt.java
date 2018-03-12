package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cover_pointContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cover_pointContextExt extends AbstractBaseExt {

	public Cover_pointContextExt(Cover_pointContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cover_pointContext getContext() {
		return (Cover_pointContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cover_point());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cover_pointContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Cover_pointContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}