package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Loop_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Loop_statementContextExt extends AbstractBaseExt {

	public Loop_statementContextExt(Loop_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Loop_statementContext getContext() {
		return (Loop_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).loop_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Loop_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Loop_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}