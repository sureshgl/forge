package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarContextExt extends AbstractBaseExt {

	public DollarContextExt(DollarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarContext getContext() {
		return (DollarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}