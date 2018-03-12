package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_actual_argContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_actual_argContextExt extends AbstractBaseExt {

	public Property_actual_argContextExt(Property_actual_argContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_actual_argContext getContext() {
		return (Property_actual_argContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_actual_arg());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_actual_argContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_actual_argContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}