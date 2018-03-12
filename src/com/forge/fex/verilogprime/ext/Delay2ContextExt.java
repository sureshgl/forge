package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delay2Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delay2ContextExt extends AbstractBaseExt {

	public Delay2ContextExt(Delay2Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delay2Context getContext() {
		return (Delay2Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delay2());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delay2Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Delay2Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}