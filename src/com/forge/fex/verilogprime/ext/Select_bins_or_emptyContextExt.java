package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Select_bins_or_emptyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Select_bins_or_emptyContextExt extends AbstractBaseExt {

	public Select_bins_or_emptyContextExt(Select_bins_or_emptyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Select_bins_or_emptyContext getContext() {
		return (Select_bins_or_emptyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).select_bins_or_empty());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Select_bins_or_emptyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Select_bins_or_emptyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}