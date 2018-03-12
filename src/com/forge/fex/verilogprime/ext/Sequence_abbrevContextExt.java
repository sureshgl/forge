package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_abbrevContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_abbrevContextExt extends AbstractBaseExt {

	public Sequence_abbrevContextExt(Sequence_abbrevContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_abbrevContext getContext() {
		return (Sequence_abbrevContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_abbrev());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_abbrevContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_abbrevContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}