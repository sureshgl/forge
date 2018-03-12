package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DivContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DivContextExt extends AbstractBaseExt {

	public DivContextExt(DivContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DivContext getContext() {
		return (DivContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).div());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DivContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DivContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}