package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_case_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_case_itemContextExt extends AbstractBaseExt {

	public Property_case_itemContextExt(Property_case_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_case_itemContext getContext() {
		return (Property_case_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_case_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_case_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_case_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}