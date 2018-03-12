package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ProgramstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ProgramstrContextExt extends AbstractBaseExt {

	public ProgramstrContextExt(ProgramstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ProgramstrContext getContext() {
		return (ProgramstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).programstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ProgramstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ProgramstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}