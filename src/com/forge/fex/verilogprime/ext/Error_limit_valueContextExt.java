package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Error_limit_valueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Error_limit_valueContextExt extends AbstractBaseExt {

	public Error_limit_valueContextExt(Error_limit_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Error_limit_valueContext getContext() {
		return (Error_limit_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).error_limit_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Error_limit_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Error_limit_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}