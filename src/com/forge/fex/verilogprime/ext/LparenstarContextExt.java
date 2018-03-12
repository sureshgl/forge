package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LparenstarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LparenstarContextExt extends AbstractBaseExt {

	public LparenstarContextExt(LparenstarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LparenstarContext getContext() {
		return (LparenstarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lparenstar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LparenstarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LparenstarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}