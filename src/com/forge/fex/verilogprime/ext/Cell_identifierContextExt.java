package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cell_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cell_identifierContextExt extends AbstractBaseExt {

	public Cell_identifierContextExt(Cell_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cell_identifierContext getContext() {
		return (Cell_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cell_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cell_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cell_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}