package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IfstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IfstrContextExt extends AbstractBaseExt {

	public IfstrContextExt(IfstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IfstrContext getContext() {
		return (IfstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ifstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IfstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IfstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}