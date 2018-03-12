package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Weight_specificationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Weight_specificationContextExt extends AbstractBaseExt {

	public Weight_specificationContextExt(Weight_specificationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Weight_specificationContext getContext() {
		return (Weight_specificationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).weight_specification());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Weight_specificationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Weight_specificationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}