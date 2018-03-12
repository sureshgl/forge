package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Strong0Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Strong0ContextExt extends AbstractBaseExt {

	public Strong0ContextExt(Strong0Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Strong0Context getContext() {
		return (Strong0Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).strong0());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Strong0Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Strong0Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}