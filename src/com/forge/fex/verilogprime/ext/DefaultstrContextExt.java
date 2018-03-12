package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DefaultstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DefaultstrContextExt extends AbstractBaseExt {

	public DefaultstrContextExt(DefaultstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DefaultstrContext getContext() {
		return (DefaultstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).defaultstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DefaultstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DefaultstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}