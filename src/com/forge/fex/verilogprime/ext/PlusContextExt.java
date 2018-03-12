package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PlusContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PlusContextExt extends AbstractBaseExt {

	public PlusContextExt(PlusContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PlusContext getContext() {
		return (PlusContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).plus());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PlusContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PlusContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}