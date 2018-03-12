package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ConststrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ConststrContextExt extends AbstractBaseExt {

	public ConststrContextExt(ConststrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ConststrContext getContext() {
		return (ConststrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).conststr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ConststrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ConststrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}