package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Open_value_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Open_value_rangeContextExt extends AbstractBaseExt {

	public Open_value_rangeContextExt(Open_value_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Open_value_rangeContext getContext() {
		return (Open_value_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).open_value_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Open_value_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Open_value_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}