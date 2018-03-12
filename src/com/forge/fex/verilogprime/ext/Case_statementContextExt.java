package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_statementContextExt extends AbstractBaseExt {

	public Case_statementContextExt(Case_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_statementContext getContext() {
		return (Case_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Case_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}