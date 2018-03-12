package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Port_referenceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Port_referenceContextExt extends AbstractBaseExt {

	public Port_referenceContextExt(Port_referenceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_referenceContext getContext() {
		return (Port_referenceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_reference());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_referenceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_referenceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}