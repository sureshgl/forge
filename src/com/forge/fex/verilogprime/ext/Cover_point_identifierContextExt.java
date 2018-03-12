package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cover_point_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cover_point_identifierContextExt extends AbstractBaseExt {

	public Cover_point_identifierContextExt(Cover_point_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cover_point_identifierContext getContext() {
		return (Cover_point_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cover_point_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cover_point_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cover_point_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}