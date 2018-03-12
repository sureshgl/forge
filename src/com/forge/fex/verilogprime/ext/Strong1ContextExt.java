package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Strong1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Strong1ContextExt extends AbstractBaseExt {

	public Strong1ContextExt(Strong1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Strong1Context getContext() {
		return (Strong1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).strong1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Strong1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Strong1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}