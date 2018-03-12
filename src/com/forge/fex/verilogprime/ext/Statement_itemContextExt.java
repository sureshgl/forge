package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Statement_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Statement_itemContextExt extends AbstractBaseExt {

	public Statement_itemContextExt(Statement_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Statement_itemContext getContext() {
		return (Statement_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).statement_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Statement_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Statement_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}