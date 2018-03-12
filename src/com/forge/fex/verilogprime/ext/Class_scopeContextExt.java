package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_scopeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_scopeContextExt extends AbstractBaseExt {

	public Class_scopeContextExt(Class_scopeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_scopeContext getContext() {
		return (Class_scopeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_scope());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_scopeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Class_scopeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}