package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Delay_valueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Delay_valueContextExt extends AbstractBaseExt {

	public Delay_valueContextExt(Delay_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Delay_valueContext getContext() {
		return (Delay_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).delay_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Delay_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Delay_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}