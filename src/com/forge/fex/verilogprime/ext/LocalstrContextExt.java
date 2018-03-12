package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LocalstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LocalstrContextExt extends AbstractBaseExt {

	public LocalstrContextExt(LocalstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LocalstrContext getContext() {
		return (LocalstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).localstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LocalstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LocalstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}