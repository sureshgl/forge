package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unsized_dimensionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unsized_dimensionContextExt extends AbstractBaseExt {

	public Unsized_dimensionContextExt(Unsized_dimensionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unsized_dimensionContext getContext() {
		return (Unsized_dimensionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unsized_dimension());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unsized_dimensionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unsized_dimensionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}