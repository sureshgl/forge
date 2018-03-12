package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UntypedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UntypedstrContextExt extends AbstractBaseExt {

	public UntypedstrContextExt(UntypedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UntypedstrContext getContext() {
		return (UntypedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).untypedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UntypedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UntypedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}