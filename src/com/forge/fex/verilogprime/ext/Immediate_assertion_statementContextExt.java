package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Immediate_assertion_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Immediate_assertion_statementContextExt extends AbstractBaseExt {

	public Immediate_assertion_statementContextExt(Immediate_assertion_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Immediate_assertion_statementContext getContext() {
		return (Immediate_assertion_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).immediate_assertion_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Immediate_assertion_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Immediate_assertion_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}