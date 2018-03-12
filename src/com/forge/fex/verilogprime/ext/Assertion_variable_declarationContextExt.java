package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assertion_variable_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assertion_variable_declarationContextExt extends AbstractBaseExt {

	public Assertion_variable_declarationContextExt(Assertion_variable_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assertion_variable_declarationContext getContext() {
		return (Assertion_variable_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assertion_variable_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assertion_variable_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assertion_variable_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}