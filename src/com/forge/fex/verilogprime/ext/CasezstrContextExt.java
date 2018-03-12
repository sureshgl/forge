package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CasezstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CasezstrContextExt extends AbstractBaseExt {

	public CasezstrContextExt(CasezstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CasezstrContext getContext() {
		return (CasezstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).casezstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CasezstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CasezstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}