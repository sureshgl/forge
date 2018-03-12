package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CellstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CellstrContextExt extends AbstractBaseExt {

	public CellstrContextExt(CellstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CellstrContext getContext() {
		return (CellstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cellstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CellstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CellstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}