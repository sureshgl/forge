package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SamplestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SamplestrContextExt extends AbstractBaseExt {

	public SamplestrContextExt(SamplestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SamplestrContext getContext() {
		return (SamplestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).samplestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SamplestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SamplestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}