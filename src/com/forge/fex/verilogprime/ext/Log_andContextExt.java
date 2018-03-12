package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Log_andContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Log_andContextExt extends AbstractBaseExt {

	public Log_andContextExt(Log_andContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Log_andContext getContext() {
		return (Log_andContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).log_and());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Log_andContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Log_andContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}