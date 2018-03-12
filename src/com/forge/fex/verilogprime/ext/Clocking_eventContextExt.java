package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_eventContextExt extends AbstractBaseExt {

	public Clocking_eventContextExt(Clocking_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_eventContext getContext() {
		return (Clocking_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}