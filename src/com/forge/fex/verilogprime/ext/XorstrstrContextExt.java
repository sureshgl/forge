package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XorstrstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XorstrstrContextExt extends AbstractBaseExt {

	public XorstrstrContextExt(XorstrstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XorstrstrContext getContext() {
		return (XorstrstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xorstrstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XorstrstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XorstrstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}