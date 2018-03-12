package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_identifierContextExt extends AbstractBaseExt {

	public Sequence_identifierContextExt(Sequence_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_identifierContext getContext() {
		return (Sequence_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}