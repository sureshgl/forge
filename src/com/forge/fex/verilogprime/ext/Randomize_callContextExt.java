package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Randomize_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Randomize_callContextExt extends AbstractBaseExt {

	public Randomize_callContextExt(Randomize_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Randomize_callContext getContext() {
		return (Randomize_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randomize_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Randomize_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Randomize_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}