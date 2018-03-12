package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Always_ffstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Always_ffstrContextExt extends AbstractBaseExt {

	public Always_ffstrContextExt(Always_ffstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Always_ffstrContext getContext() {
		return (Always_ffstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).always_ffstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Always_ffstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Always_ffstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}