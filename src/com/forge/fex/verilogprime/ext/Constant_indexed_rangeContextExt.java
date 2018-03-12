package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_indexed_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_indexed_rangeContextExt extends AbstractBaseExt {

	public Constant_indexed_rangeContextExt(Constant_indexed_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_indexed_rangeContext getContext() {
		return (Constant_indexed_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_indexed_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_indexed_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_indexed_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}