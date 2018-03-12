package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Index_variable_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Index_variable_identifierContextExt extends AbstractBaseExt {

	public Index_variable_identifierContextExt(Index_variable_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Index_variable_identifierContext getContext() {
		return (Index_variable_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).index_variable_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Index_variable_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Index_variable_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}