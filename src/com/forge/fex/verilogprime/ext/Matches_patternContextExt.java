package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Matches_patternContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Matches_patternContextExt extends AbstractBaseExt {

	public Matches_patternContextExt(Matches_patternContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Matches_patternContext getContext() {
		return (Matches_patternContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).matches_pattern());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Matches_patternContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Matches_patternContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}