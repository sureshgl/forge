package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_constraintContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_constraintContextExt extends AbstractBaseExt {

	public Class_constraintContextExt(Class_constraintContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_constraintContext getContext() {
		return (Class_constraintContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_constraint());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_constraintContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_constraintContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}