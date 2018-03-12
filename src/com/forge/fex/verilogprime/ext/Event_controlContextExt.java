package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Event_controlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Event_controlContextExt extends AbstractBaseExt {

	public Event_controlContextExt(Event_controlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Event_controlContext getContext() {
		return (Event_controlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).event_control());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Event_controlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Event_controlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}