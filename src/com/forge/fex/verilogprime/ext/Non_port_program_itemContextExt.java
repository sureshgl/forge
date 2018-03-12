package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Non_port_program_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Non_port_program_itemContextExt extends AbstractBaseExt {

	public Non_port_program_itemContextExt(Non_port_program_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Non_port_program_itemContext getContext() {
		return (Non_port_program_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).non_port_program_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Non_port_program_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Non_port_program_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}