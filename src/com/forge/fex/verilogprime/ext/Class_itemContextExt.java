package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_itemContextExt extends AbstractBaseExt {

	public Class_itemContextExt(Class_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_itemContext getContext() {
		return (Class_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Class_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}