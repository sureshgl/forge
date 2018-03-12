package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PatternContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PatternContextExt extends AbstractBaseExt {

	public PatternContextExt(PatternContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PatternContext getContext() {
		return (PatternContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pattern());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PatternContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PatternContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}