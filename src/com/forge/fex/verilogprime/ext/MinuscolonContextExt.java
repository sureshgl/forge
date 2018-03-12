package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.MinuscolonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class MinuscolonContextExt extends AbstractBaseExt {

	public MinuscolonContextExt(MinuscolonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MinuscolonContext getContext() {
		return (MinuscolonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).minuscolon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MinuscolonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MinuscolonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}