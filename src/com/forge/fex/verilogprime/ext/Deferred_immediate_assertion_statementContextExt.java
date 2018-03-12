package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Deferred_immediate_assertion_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Deferred_immediate_assertion_statementContextExt extends AbstractBaseExt {

	public Deferred_immediate_assertion_statementContextExt(Deferred_immediate_assertion_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Deferred_immediate_assertion_statementContext getContext() {
		return (Deferred_immediate_assertion_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).deferred_immediate_assertion_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Deferred_immediate_assertion_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Deferred_immediate_assertion_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}