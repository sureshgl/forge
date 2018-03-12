package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Virtual_interface_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Virtual_interface_declarationContextExt extends AbstractBaseExt {

	public Virtual_interface_declarationContextExt(Virtual_interface_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Virtual_interface_declarationContext getContext() {
		return (Virtual_interface_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).virtual_interface_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Virtual_interface_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Virtual_interface_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}