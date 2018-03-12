package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Randcase_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Randcase_statementContextExt extends AbstractBaseExt {

	public Randcase_statementContextExt(Randcase_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Randcase_statementContext getContext() {
		return (Randcase_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randcase_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Randcase_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Randcase_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}