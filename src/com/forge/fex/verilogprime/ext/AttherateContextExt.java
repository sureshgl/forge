package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AttherateContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AttherateContextExt extends AbstractBaseExt {

	public AttherateContextExt(AttherateContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AttherateContext getContext() {
		return (AttherateContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attherate());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AttherateContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AttherateContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}