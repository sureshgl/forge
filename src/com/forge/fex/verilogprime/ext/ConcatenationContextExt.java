package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ConcatenationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ConcatenationContextExt extends AbstractBaseExt {

	public ConcatenationContextExt(ConcatenationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ConcatenationContext getContext() {
		return (ConcatenationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).concatenation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ConcatenationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ConcatenationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}