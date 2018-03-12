package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Function_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Function_identifierContextExt extends AbstractBaseExt {

	public Function_identifierContextExt(Function_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Function_identifierContext getContext() {
		return (Function_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).function_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Function_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Function_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}