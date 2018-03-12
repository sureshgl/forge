package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pulsestyle_ondetectstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pulsestyle_ondetectstrContextExt extends AbstractBaseExt {

	public Pulsestyle_ondetectstrContextExt(Pulsestyle_ondetectstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pulsestyle_ondetectstrContext getContext() {
		return (Pulsestyle_ondetectstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulsestyle_ondetectstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pulsestyle_ondetectstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pulsestyle_ondetectstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}