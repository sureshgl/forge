package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.InitialstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class InitialstrContextExt extends AbstractBaseExt {

	public InitialstrContextExt(InitialstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InitialstrContext getContext() {
		return (InitialstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).initialstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InitialstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InitialstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}