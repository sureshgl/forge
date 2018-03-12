package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cover_sequence_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cover_sequence_statementContextExt extends AbstractBaseExt {

	public Cover_sequence_statementContextExt(Cover_sequence_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cover_sequence_statementContext getContext() {
		return (Cover_sequence_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cover_sequence_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cover_sequence_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cover_sequence_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}