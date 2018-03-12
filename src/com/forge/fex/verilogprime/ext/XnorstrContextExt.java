package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XnorstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XnorstrContextExt extends AbstractBaseExt {

	public XnorstrContextExt(XnorstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XnorstrContext getContext() {
		return (XnorstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xnorstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XnorstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XnorstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}