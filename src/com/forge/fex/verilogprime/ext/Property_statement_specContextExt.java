package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_statement_specContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_statement_specContextExt extends AbstractBaseExt {

	public Property_statement_specContextExt(Property_statement_specContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_statement_specContext getContext() {
		return (Property_statement_specContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_statement_spec());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_statement_specContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_statement_specContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}