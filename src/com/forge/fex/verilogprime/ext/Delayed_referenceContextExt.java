package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delayed_referenceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delayed_referenceContextExt extends AbstractBaseExt {

	public Delayed_referenceContextExt(Delayed_referenceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delayed_referenceContext getContext() {
		return (Delayed_referenceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delayed_reference());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delayed_referenceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Delayed_referenceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}