package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PosedgestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PosedgestrContextExt extends AbstractBaseExt {

	public PosedgestrContextExt(PosedgestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PosedgestrContext getContext() {
		return (PosedgestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).posedgestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PosedgestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PosedgestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}