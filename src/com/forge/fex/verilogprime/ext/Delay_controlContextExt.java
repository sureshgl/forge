package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delay_controlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delay_controlContextExt extends AbstractBaseExt {

	public Delay_controlContextExt(Delay_controlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delay_controlContext getContext() {
		return (Delay_controlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delay_control());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delay_controlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Delay_controlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}