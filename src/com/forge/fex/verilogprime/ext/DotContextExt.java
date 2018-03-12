package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DotContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DotContextExt extends AbstractBaseExt {

	public DotContextExt(DotContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DotContext getContext() {
		return (DotContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dot());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DotContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DotContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}