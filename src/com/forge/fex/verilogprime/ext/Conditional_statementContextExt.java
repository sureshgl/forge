package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Conditional_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Conditional_statementContextExt extends AbstractBaseExt {

	public Conditional_statementContextExt(Conditional_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Conditional_statementContext getContext() {
		return (Conditional_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).conditional_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Conditional_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Conditional_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}