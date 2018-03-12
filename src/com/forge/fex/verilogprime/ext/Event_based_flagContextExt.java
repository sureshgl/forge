package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Event_based_flagContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Event_based_flagContextExt extends AbstractBaseExt {

	public Event_based_flagContextExt(Event_based_flagContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Event_based_flagContext getContext() {
		return (Event_based_flagContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).event_based_flag());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Event_based_flagContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Event_based_flagContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}