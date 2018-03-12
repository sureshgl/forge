package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NullstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NullstrContextExt extends AbstractBaseExt {

	public NullstrContextExt(NullstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NullstrContext getContext() {
		return (NullstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nullstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NullstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NullstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}