package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_identifierContextExt extends AbstractBaseExt {

	public Property_identifierContextExt(Property_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_identifierContext getContext() {
		return (Property_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}