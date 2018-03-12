package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EqualsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EqualsContextExt extends AbstractBaseExt {

	public EqualsContextExt(EqualsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EqualsContext getContext() {
		return (EqualsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).equals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EqualsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EqualsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}