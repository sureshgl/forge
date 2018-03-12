package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hierarchical_event_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hierarchical_event_identifierContextExt extends AbstractBaseExt {

	public Hierarchical_event_identifierContextExt(Hierarchical_event_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hierarchical_event_identifierContext getContext() {
		return (Hierarchical_event_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hierarchical_event_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hierarchical_event_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hierarchical_event_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}