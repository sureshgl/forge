package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CasexstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CasexstrContextExt extends AbstractBaseExt {

	public CasexstrContextExt(CasexstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CasexstrContext getContext() {
		return (CasexstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).casexstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CasexstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CasexstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}