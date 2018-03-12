package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DecrementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DecrementContextExt extends AbstractBaseExt {

	public DecrementContextExt(DecrementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DecrementContext getContext() {
		return (DecrementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).decrement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DecrementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DecrementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}