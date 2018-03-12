package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XnorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XnorContextExt extends AbstractBaseExt {

	public XnorContextExt(XnorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XnorContext getContext() {
		return (XnorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xnor());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XnorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XnorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}