package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Slice_sizeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Slice_sizeContextExt extends AbstractBaseExt {

	public Slice_sizeContextExt(Slice_sizeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Slice_sizeContext getContext() {
		return (Slice_sizeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slice_size());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Slice_sizeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Slice_sizeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}