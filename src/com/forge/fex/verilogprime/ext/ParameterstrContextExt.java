package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ParameterstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ParameterstrContextExt extends AbstractBaseExt {

	public ParameterstrContextExt(ParameterstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ParameterstrContext getContext() {
		return (ParameterstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameterstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ParameterstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ParameterstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}