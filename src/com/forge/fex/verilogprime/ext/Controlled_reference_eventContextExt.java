package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Controlled_reference_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Controlled_reference_eventContextExt extends AbstractBaseExt {

	public Controlled_reference_eventContextExt(Controlled_reference_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Controlled_reference_eventContext getContext() {
		return (Controlled_reference_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).controlled_reference_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Controlled_reference_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Controlled_reference_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}