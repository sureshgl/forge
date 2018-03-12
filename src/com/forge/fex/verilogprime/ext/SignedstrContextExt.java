package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SignedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SignedstrContextExt extends AbstractBaseExt {

	public SignedstrContextExt(SignedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SignedstrContext getContext() {
		return (SignedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).signedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SignedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SignedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}