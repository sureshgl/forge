package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_list_of_argumentsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_list_of_argumentsContextExt extends AbstractBaseExt {

	public Property_list_of_argumentsContextExt(Property_list_of_argumentsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_list_of_argumentsContext getContext() {
		return (Property_list_of_argumentsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_list_of_arguments());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_list_of_argumentsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_list_of_argumentsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}