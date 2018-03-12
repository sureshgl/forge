package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Strength1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Strength1ContextExt extends AbstractBaseExt {

	public Strength1ContextExt(Strength1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Strength1Context getContext() {
		return (Strength1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).strength1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Strength1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Strength1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}