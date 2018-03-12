package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Liblist_clauseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Liblist_clauseContextExt extends AbstractBaseExt {

	public Liblist_clauseContextExt(Liblist_clauseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Liblist_clauseContext getContext() {
		return (Liblist_clauseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).liblist_clause());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Liblist_clauseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Liblist_clauseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}