package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tf_callContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tf_callContextExt extends AbstractBaseExt {

	public Tf_callContextExt(Tf_callContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tf_callContext getContext() {
		return (Tf_callContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tf_call());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tf_callContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tf_callContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}