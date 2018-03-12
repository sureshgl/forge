package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Indexed_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Indexed_rangeContextExt extends AbstractBaseExt {

	public Indexed_rangeContextExt(Indexed_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Indexed_rangeContext getContext() {
		return (Indexed_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).indexed_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Indexed_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Indexed_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}