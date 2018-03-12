package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ColonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ColonContextExt extends AbstractBaseExt {

	public ColonContextExt(ColonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ColonContext getContext() {
		return (ColonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).colon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ColonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ColonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}