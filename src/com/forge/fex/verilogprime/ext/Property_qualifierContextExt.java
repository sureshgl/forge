package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_qualifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_qualifierContextExt extends AbstractBaseExt {

	public Property_qualifierContextExt(Property_qualifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_qualifierContext getContext() {
		return (Property_qualifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_qualifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_qualifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_qualifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}