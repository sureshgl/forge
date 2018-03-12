package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_declarationContextExt extends AbstractBaseExt {

	public Class_declarationContextExt(Class_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_declarationContext getContext() {
		return (Class_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}