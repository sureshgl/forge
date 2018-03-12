package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndpropertystrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndpropertystrContextExt extends AbstractBaseExt {

	public EndpropertystrContextExt(EndpropertystrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndpropertystrContext getContext() {
		return (EndpropertystrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endpropertystr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndpropertystrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndpropertystrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}