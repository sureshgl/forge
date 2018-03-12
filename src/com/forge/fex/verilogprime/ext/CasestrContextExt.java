package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CasestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CasestrContextExt extends AbstractBaseExt {

	public CasestrContextExt(CasestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CasestrContext getContext() {
		return (CasestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).casestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CasestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CasestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}