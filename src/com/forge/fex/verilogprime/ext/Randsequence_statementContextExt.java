package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Randsequence_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Randsequence_statementContextExt extends AbstractBaseExt {

	public Randsequence_statementContextExt(Randsequence_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Randsequence_statementContext getContext() {
		return (Randsequence_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randsequence_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Randsequence_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Randsequence_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}