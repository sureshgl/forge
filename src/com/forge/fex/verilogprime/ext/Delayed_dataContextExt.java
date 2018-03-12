package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delayed_dataContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delayed_dataContextExt extends AbstractBaseExt {

	public Delayed_dataContextExt(Delayed_dataContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delayed_dataContext getContext() {
		return (Delayed_dataContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delayed_data());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delayed_dataContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Delayed_dataContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}