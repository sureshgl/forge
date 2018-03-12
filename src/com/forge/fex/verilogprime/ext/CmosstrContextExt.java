package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CmosstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CmosstrContextExt extends AbstractBaseExt {

	public CmosstrContextExt(CmosstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CmosstrContext getContext() {
		return (CmosstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cmosstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CmosstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CmosstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}