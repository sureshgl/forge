package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TriandstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TriandstrContextExt extends AbstractBaseExt {

	public TriandstrContextExt(TriandstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TriandstrContext getContext() {
		return (TriandstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).triandstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TriandstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TriandstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}