package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Statement_or_nullContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Statement_or_nullContextExt extends AbstractBaseExt {

	public Statement_or_nullContextExt(Statement_or_nullContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Statement_or_nullContext getContext() {
		return (Statement_or_nullContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).statement_or_null());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Statement_or_nullContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Statement_or_nullContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}