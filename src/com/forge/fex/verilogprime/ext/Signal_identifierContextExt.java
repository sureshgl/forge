package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Signal_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Signal_identifierContextExt extends AbstractBaseExt {

	public Signal_identifierContextExt(Signal_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Signal_identifierContext getContext() {
		return (Signal_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).signal_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Signal_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Signal_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}