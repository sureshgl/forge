package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarrootstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarrootstrContextExt extends AbstractBaseExt {

	public DollarrootstrContextExt(DollarrootstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarrootstrContext getContext() {
		return (DollarrootstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarrootstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarrootstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarrootstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}