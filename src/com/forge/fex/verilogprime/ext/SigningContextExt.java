package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SigningContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SigningContextExt extends AbstractBaseExt {

	public SigningContextExt(SigningContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SigningContext getContext() {
		return (SigningContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).signing());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SigningContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SigningContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}