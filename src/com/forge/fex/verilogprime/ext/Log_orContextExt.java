package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Log_orContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Log_orContextExt extends AbstractBaseExt {

	public Log_orContextExt(Log_orContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Log_orContext getContext() {
		return (Log_orContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).log_or());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Log_orContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Log_orContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}