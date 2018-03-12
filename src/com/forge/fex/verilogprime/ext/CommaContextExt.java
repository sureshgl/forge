package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CommaContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CommaContextExt extends AbstractBaseExt {

	public CommaContextExt(CommaContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CommaContext getContext() {
		return (CommaContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).comma());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CommaContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CommaContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}