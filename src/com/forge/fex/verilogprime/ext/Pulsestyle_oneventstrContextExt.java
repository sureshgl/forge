package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pulsestyle_oneventstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pulsestyle_oneventstrContextExt extends AbstractBaseExt {

	public Pulsestyle_oneventstrContextExt(Pulsestyle_oneventstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pulsestyle_oneventstrContext getContext() {
		return (Pulsestyle_oneventstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulsestyle_oneventstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pulsestyle_oneventstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pulsestyle_oneventstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}