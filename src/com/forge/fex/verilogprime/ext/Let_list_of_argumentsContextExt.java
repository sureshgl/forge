package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Let_list_of_argumentsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Let_list_of_argumentsContextExt extends AbstractBaseExt {

	public Let_list_of_argumentsContextExt(Let_list_of_argumentsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Let_list_of_argumentsContext getContext() {
		return (Let_list_of_argumentsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).let_list_of_arguments());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Let_list_of_argumentsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Let_list_of_argumentsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}