package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AutomaticstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AutomaticstrContextExt extends AbstractBaseExt {

	public AutomaticstrContextExt(AutomaticstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AutomaticstrContext getContext() {
		return (AutomaticstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).automaticstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AutomaticstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AutomaticstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}