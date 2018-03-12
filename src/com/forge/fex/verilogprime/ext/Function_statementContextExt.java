package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Function_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Function_statementContextExt extends AbstractBaseExt {

	public Function_statementContextExt(Function_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Function_statementContext getContext() {
		return (Function_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).function_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Function_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Function_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}