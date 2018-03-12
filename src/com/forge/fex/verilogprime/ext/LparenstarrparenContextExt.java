package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LparenstarrparenContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LparenstarrparenContextExt extends AbstractBaseExt {

	public LparenstarrparenContextExt(LparenstarrparenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LparenstarrparenContext getContext() {
		return (LparenstarrparenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lparenstarrparen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LparenstarrparenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ LparenstarrparenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}