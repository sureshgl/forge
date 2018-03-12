package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Port_directionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Port_directionContextExt extends AbstractBaseExt {

	public Port_directionContextExt(Port_directionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_directionContext getContext() {
		return (Port_directionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_direction());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_directionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_directionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}