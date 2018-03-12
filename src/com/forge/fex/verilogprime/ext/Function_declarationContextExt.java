package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Function_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Function_declarationContextExt extends AbstractBaseExt {

	public Function_declarationContextExt(Function_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Function_declarationContext getContext() {
		return (Function_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).function_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Function_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Function_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}