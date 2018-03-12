package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Repeat_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Repeat_rangeContextExt extends AbstractBaseExt {

	public Repeat_rangeContextExt(Repeat_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Repeat_rangeContext getContext() {
		return (Repeat_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).repeat_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Repeat_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Repeat_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}