package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Part_select_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Part_select_rangeContextExt extends AbstractBaseExt {

	public Part_select_rangeContextExt(Part_select_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Part_select_rangeContext getContext() {
		return (Part_select_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).part_select_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Part_select_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Part_select_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}