package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndprimitivestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndprimitivestrContextExt extends AbstractBaseExt {

	public EndprimitivestrContextExt(EndprimitivestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndprimitivestrContext getContext() {
		return (EndprimitivestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endprimitivestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndprimitivestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndprimitivestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}