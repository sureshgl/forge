package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DescriptionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DescriptionContextExt extends AbstractBaseExt {

	public DescriptionContextExt(DescriptionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DescriptionContext getContext() {
		return (DescriptionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).description());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DescriptionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DescriptionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}