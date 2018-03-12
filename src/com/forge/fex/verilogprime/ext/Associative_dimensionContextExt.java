package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Associative_dimensionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Associative_dimensionContextExt extends AbstractBaseExt {

	public Associative_dimensionContextExt(Associative_dimensionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Associative_dimensionContext getContext() {
		return (Associative_dimensionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).associative_dimension());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Associative_dimensionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Associative_dimensionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}