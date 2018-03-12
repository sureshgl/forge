package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_defparam_assignmentsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_defparam_assignmentsContextExt extends AbstractBaseExt {

	public List_of_defparam_assignmentsContextExt(List_of_defparam_assignmentsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_defparam_assignmentsContext getContext() {
		return (List_of_defparam_assignmentsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_defparam_assignments());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_defparam_assignmentsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_defparam_assignmentsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}