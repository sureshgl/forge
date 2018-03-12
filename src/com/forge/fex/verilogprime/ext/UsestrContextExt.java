package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UsestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UsestrContextExt extends AbstractBaseExt {

	public UsestrContextExt(UsestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UsestrContext getContext() {
		return (UsestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).usestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UsestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UsestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}