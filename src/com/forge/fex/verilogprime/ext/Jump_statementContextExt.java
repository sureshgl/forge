package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Jump_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Jump_statementContextExt extends AbstractBaseExt {

	public Jump_statementContextExt(Jump_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Jump_statementContext getContext() {
		return (Jump_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).jump_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Jump_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Jump_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}