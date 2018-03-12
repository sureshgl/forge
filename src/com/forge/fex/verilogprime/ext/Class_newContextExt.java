package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_newContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_newContextExt extends AbstractBaseExt {

	public Class_newContextExt(Class_newContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_newContext getContext() {
		return (Class_newContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_new());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_newContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Class_newContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}