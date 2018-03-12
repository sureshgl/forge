package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_methodContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_methodContextExt extends AbstractBaseExt {

	public Class_methodContextExt(Class_methodContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_methodContext getContext() {
		return (Class_methodContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_method());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_methodContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Class_methodContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}