package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SequencestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SequencestrContextExt extends AbstractBaseExt {

	public SequencestrContextExt(SequencestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SequencestrContext getContext() {
		return (SequencestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequencestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SequencestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SequencestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}