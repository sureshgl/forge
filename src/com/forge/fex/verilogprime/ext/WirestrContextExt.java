package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.WirestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class WirestrContextExt extends AbstractBaseExt {

	public WirestrContextExt(WirestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WirestrContext getContext() {
		return (WirestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wirestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WirestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WirestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}