package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_exprContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_exprContextExt extends AbstractBaseExt {

	public Property_exprContextExt(Property_exprContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_exprContext getContext() {
		return (Property_exprContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_expr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_exprContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Property_exprContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}