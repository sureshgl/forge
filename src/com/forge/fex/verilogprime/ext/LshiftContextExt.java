package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LshiftContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LshiftContextExt extends AbstractBaseExt {

	public LshiftContextExt(LshiftContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LshiftContext getContext() {
		return (LshiftContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lshift());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LshiftContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LshiftContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}