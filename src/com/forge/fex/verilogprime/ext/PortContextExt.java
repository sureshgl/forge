package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PortContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PortContextExt extends AbstractBaseExt {

	public PortContextExt(PortContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortContext getContext() {
		return (PortContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}