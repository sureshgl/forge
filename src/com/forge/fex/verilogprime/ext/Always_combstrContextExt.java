package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Always_combstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Always_combstrContextExt extends AbstractBaseExt {

	public Always_combstrContextExt(Always_combstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Always_combstrContext getContext() {
		return (Always_combstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).always_combstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Always_combstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Always_combstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}