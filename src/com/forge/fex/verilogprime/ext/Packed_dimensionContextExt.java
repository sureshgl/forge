package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Packed_dimensionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Packed_dimensionContextExt extends AbstractBaseExt {

	public Packed_dimensionContextExt(Packed_dimensionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Packed_dimensionContext getContext() {
		return (Packed_dimensionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).packed_dimension());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Packed_dimensionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Packed_dimensionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}