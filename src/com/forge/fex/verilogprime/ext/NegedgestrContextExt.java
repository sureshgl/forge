package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NegedgestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NegedgestrContextExt extends AbstractBaseExt {

	public NegedgestrContextExt(NegedgestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NegedgestrContext getContext() {
		return (NegedgestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).negedgestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NegedgestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NegedgestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}