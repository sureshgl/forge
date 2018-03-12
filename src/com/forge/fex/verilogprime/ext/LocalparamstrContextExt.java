package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LocalparamstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LocalparamstrContextExt extends AbstractBaseExt {

	public LocalparamstrContextExt(LocalparamstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LocalparamstrContext getContext() {
		return (LocalparamstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).localparamstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LocalparamstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LocalparamstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}