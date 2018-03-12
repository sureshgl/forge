package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Value_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Value_rangeContextExt extends AbstractBaseExt {

	public Value_rangeContextExt(Value_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Value_rangeContext getContext() {
		return (Value_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).value_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Value_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Value_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}