package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LtContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LtContextExt extends AbstractBaseExt {

	public LtContextExt(LtContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LtContext getContext() {
		return (LtContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lt());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LtContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LtContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}