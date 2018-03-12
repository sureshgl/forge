package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.CastContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class CastContextExt extends AbstractBaseExt {

	public CastContextExt(CastContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public CastContext getContext() {
		return (CastContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cast());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof CastContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + CastContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}