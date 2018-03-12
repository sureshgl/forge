package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cell_clauseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cell_clauseContextExt extends AbstractBaseExt {

	public Cell_clauseContextExt(Cell_clauseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cell_clauseContext getContext() {
		return (Cell_clauseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cell_clause());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cell_clauseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Cell_clauseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}