package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Class_variable_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Class_variable_identifierContextExt extends AbstractBaseExt {

	public Class_variable_identifierContextExt(Class_variable_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Class_variable_identifierContext getContext() {
		return (Class_variable_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).class_variable_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Class_variable_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Class_variable_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}