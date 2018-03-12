package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Restrict_property_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Restrict_property_statementContextExt extends AbstractBaseExt {

	public Restrict_property_statementContextExt(Restrict_property_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Restrict_property_statementContext getContext() {
		return (Restrict_property_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).restrict_property_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Restrict_property_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Restrict_property_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}