package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Controlled_timing_check_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Controlled_timing_check_eventContextExt extends AbstractBaseExt {

	public Controlled_timing_check_eventContextExt(Controlled_timing_check_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Controlled_timing_check_eventContext getContext() {
		return (Controlled_timing_check_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).controlled_timing_check_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Controlled_timing_check_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Controlled_timing_check_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}