package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_typeContextExt extends AbstractBaseExt {

	public Class_typeContextExt(Class_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_typeContext getContext() {
		return (Class_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Class_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}