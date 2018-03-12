package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Non_integer_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Non_integer_typeContextExt extends AbstractBaseExt {

	public Non_integer_typeContextExt(Non_integer_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Non_integer_typeContext getContext() {
		return (Non_integer_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).non_integer_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Non_integer_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Non_integer_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}