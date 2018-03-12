package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assert_property_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assert_property_statementContextExt extends AbstractBaseExt {

	public Assert_property_statementContextExt(Assert_property_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assert_property_statementContext getContext() {
		return (Assert_property_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assert_property_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assert_property_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assert_property_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}