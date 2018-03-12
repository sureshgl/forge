package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Default_clauseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Default_clauseContextExt extends AbstractBaseExt {

	public Default_clauseContextExt(Default_clauseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Default_clauseContext getContext() {
		return (Default_clauseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).default_clause());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Default_clauseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Default_clauseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}