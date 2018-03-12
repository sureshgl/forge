package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EnumstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EnumstrContextExt extends AbstractBaseExt {

	public EnumstrContextExt(EnumstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EnumstrContext getContext() {
		return (EnumstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enumstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EnumstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EnumstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}