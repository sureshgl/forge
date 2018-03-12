package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Zero_or_oneContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Zero_or_oneContextExt extends AbstractBaseExt {

	public Zero_or_oneContextExt(Zero_or_oneContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Zero_or_oneContext getContext() {
		return (Zero_or_oneContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).zero_or_one());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Zero_or_oneContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Zero_or_oneContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}