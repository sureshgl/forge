package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PrimaryContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PrimaryContextExt extends AbstractBaseExt {

	public PrimaryContextExt(PrimaryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PrimaryContext getContext() {
		return (PrimaryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).primary());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PrimaryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PrimaryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}