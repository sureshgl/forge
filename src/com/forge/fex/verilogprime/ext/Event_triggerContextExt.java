package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Event_triggerContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Event_triggerContextExt extends AbstractBaseExt {

	public Event_triggerContextExt(Event_triggerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Event_triggerContext getContext() {
		return (Event_triggerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).event_trigger());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Event_triggerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Event_triggerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}