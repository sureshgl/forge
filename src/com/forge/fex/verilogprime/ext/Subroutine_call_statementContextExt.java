package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Subroutine_call_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Subroutine_call_statementContextExt extends AbstractBaseExt {

	public Subroutine_call_statementContextExt(Subroutine_call_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Subroutine_call_statementContext getContext() {
		return (Subroutine_call_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).subroutine_call_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Subroutine_call_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Subroutine_call_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}