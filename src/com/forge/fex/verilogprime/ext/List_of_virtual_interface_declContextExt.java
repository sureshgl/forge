package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_virtual_interface_declContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_virtual_interface_declContextExt extends AbstractBaseExt {

	public List_of_virtual_interface_declContextExt(List_of_virtual_interface_declContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_virtual_interface_declContext getContext() {
		return (List_of_virtual_interface_declContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_virtual_interface_decl());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_virtual_interface_declContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_virtual_interface_declContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}