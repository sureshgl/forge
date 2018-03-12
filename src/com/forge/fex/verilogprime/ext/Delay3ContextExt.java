package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delay3Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delay3ContextExt extends AbstractBaseExt {

	public Delay3ContextExt(Delay3Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delay3Context getContext() {
		return (Delay3Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delay3());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delay3Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Delay3Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}