package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_item_qualifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_item_qualifierContextExt extends AbstractBaseExt {

	public Class_item_qualifierContextExt(Class_item_qualifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_item_qualifierContext getContext() {
		return (Class_item_qualifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_item_qualifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_item_qualifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_item_qualifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}