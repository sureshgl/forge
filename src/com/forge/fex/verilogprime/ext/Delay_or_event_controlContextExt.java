package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delay_or_event_controlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delay_or_event_controlContextExt extends AbstractBaseExt {

	public Delay_or_event_controlContextExt(Delay_or_event_controlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delay_or_event_controlContext getContext() {
		return (Delay_or_event_controlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delay_or_event_control());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delay_or_event_controlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Delay_or_event_controlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}