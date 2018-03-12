package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_constructor_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_constructor_declarationContextExt extends AbstractBaseExt {

	public Class_constructor_declarationContextExt(Class_constructor_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_constructor_declarationContext getContext() {
		return (Class_constructor_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_constructor_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_constructor_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_constructor_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}