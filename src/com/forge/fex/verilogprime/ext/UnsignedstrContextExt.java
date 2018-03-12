package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UnsignedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UnsignedstrContextExt extends AbstractBaseExt {

	public UnsignedstrContextExt(UnsignedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UnsignedstrContext getContext() {
		return (UnsignedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unsignedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UnsignedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UnsignedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}