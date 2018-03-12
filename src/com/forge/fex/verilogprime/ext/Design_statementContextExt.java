package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Design_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Design_statementContextExt extends AbstractBaseExt {

	public Design_statementContextExt(Design_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Design_statementContext getContext() {
		return (Design_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).design_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Design_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Design_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}