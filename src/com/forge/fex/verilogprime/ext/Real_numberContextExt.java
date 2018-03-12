package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Real_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Real_numberContextExt extends AbstractBaseExt {

	public Real_numberContextExt(Real_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Real_numberContext getContext() {
		return (Real_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).real_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Real_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Real_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}