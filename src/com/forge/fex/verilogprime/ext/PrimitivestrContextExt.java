package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PrimitivestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PrimitivestrContextExt extends AbstractBaseExt {

	public PrimitivestrContextExt(PrimitivestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PrimitivestrContext getContext() {
		return (PrimitivestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).primitivestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PrimitivestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PrimitivestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}