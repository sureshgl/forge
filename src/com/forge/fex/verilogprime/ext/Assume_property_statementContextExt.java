package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assume_property_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assume_property_statementContextExt extends AbstractBaseExt {

	public Assume_property_statementContextExt(Assume_property_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assume_property_statementContext getContext() {
		return (Assume_property_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assume_property_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assume_property_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assume_property_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}