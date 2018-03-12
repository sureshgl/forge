package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.MinusContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class MinusContextExt extends AbstractBaseExt {

	public MinusContextExt(MinusContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MinusContext getContext() {
		return (MinusContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).minus());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MinusContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MinusContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}