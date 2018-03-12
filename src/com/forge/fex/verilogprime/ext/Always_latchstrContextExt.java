package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Always_latchstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Always_latchstrContextExt extends AbstractBaseExt {

	public Always_latchstrContextExt(Always_latchstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Always_latchstrContext getContext() {
		return (Always_latchstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).always_latchstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Always_latchstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Always_latchstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}