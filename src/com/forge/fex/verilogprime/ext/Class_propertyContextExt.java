package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_propertyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_propertyContextExt extends AbstractBaseExt {

	public Class_propertyContextExt(Class_propertyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_propertyContext getContext() {
		return (Class_propertyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_property());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_propertyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_propertyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}