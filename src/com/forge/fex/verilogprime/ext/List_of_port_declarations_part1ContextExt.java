package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_port_declarations_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_port_declarations_part1ContextExt extends AbstractBaseExt {

	public List_of_port_declarations_part1ContextExt(List_of_port_declarations_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_port_declarations_part1Context getContext() {
		return (List_of_port_declarations_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_port_declarations_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_port_declarations_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_port_declarations_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}