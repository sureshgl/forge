package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_clocking_decl_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_clocking_decl_assignContextExt extends AbstractBaseExt {

	public List_of_clocking_decl_assignContextExt(List_of_clocking_decl_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_clocking_decl_assignContext getContext() {
		return (List_of_clocking_decl_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_clocking_decl_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_clocking_decl_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_clocking_decl_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}