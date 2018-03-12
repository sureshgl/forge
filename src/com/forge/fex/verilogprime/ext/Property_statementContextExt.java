package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_statementContextExt extends AbstractBaseExt {

	public Property_statementContextExt(Property_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_statementContext getContext() {
		return (Property_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}