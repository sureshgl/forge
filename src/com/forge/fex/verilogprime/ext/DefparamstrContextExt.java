package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DefparamstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DefparamstrContextExt extends AbstractBaseExt {

	public DefparamstrContextExt(DefparamstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DefparamstrContext getContext() {
		return (DefparamstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).defparamstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DefparamstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DefparamstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}