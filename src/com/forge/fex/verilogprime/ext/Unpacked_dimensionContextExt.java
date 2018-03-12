package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unpacked_dimensionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unpacked_dimensionContextExt extends AbstractBaseExt {

	public Unpacked_dimensionContextExt(Unpacked_dimensionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unpacked_dimensionContext getContext() {
		return (Unpacked_dimensionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unpacked_dimension());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unpacked_dimensionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unpacked_dimensionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}