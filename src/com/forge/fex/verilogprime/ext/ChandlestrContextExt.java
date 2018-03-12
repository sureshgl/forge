package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ChandlestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ChandlestrContextExt extends AbstractBaseExt {

	public ChandlestrContextExt(ChandlestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ChandlestrContext getContext() {
		return (ChandlestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).chandlestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ChandlestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ChandlestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}