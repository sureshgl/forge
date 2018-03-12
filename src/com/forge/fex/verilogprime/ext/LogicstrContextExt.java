package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LogicstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LogicstrContextExt extends AbstractBaseExt {

	public LogicstrContextExt(LogicstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LogicstrContext getContext() {
		return (LogicstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).logicstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LogicstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LogicstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}