package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Variable_dimensionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Variable_dimensionContextExt extends AbstractBaseExt {

	public Variable_dimensionContextExt(Variable_dimensionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Variable_dimensionContext getContext() {
		return (Variable_dimensionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).variable_dimension());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Variable_dimensionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Variable_dimensionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}