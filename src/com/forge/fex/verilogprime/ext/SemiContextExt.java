package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SemiContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SemiContextExt extends AbstractBaseExt {

	public SemiContextExt(SemiContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SemiContext getContext() {
		return (SemiContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).semi());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SemiContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SemiContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}