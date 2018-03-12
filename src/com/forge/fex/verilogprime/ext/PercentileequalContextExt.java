package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PercentileequalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PercentileequalContextExt extends AbstractBaseExt {

	public PercentileequalContextExt(PercentileequalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PercentileequalContext getContext() {
		return (PercentileequalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).percentileequal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PercentileequalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ PercentileequalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}