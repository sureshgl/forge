package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Range_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Range_listContextExt extends AbstractBaseExt {

	public Range_listContextExt(Range_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Range_listContext getContext() {
		return (Range_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).range_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Range_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Range_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}