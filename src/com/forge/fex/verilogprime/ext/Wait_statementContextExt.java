package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Wait_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Wait_statementContextExt extends AbstractBaseExt {

	public Wait_statementContextExt(Wait_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Wait_statementContext getContext() {
		return (Wait_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wait_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Wait_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Wait_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}