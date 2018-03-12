package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parameter_overrideContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Parameter_overrideContextExt extends AbstractBaseExt {

	public Parameter_overrideContextExt(Parameter_overrideContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_overrideContext getContext() {
		return (Parameter_overrideContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_override());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_overrideContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_overrideContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}