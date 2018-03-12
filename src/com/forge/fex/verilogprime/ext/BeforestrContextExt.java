package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BeforestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BeforestrContextExt extends AbstractBaseExt {

	public BeforestrContextExt(BeforestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BeforestrContext getContext() {
		return (BeforestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).beforestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BeforestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BeforestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}