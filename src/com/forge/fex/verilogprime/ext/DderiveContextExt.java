package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DderiveContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DderiveContextExt extends AbstractBaseExt {

	public DderiveContextExt(DderiveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DderiveContext getContext() {
		return (DderiveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dderive());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DderiveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DderiveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}