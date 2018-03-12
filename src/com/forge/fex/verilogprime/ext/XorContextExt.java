package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XorContextExt extends AbstractBaseExt {

	public XorContextExt(XorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XorContext getContext() {
		return (XorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xor());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}