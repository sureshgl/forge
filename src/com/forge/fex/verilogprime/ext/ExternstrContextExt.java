package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExternstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ExternstrContextExt extends AbstractBaseExt {

	public ExternstrContextExt(ExternstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ExternstrContext getContext() {
		return (ExternstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).externstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ExternstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ExternstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}