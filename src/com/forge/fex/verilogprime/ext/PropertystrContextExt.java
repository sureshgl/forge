package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PropertystrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PropertystrContextExt extends AbstractBaseExt {

	public PropertystrContextExt(PropertystrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PropertystrContext getContext() {
		return (PropertystrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).propertystr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PropertystrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PropertystrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}