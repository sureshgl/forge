package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Property_lvar_port_directionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Property_lvar_port_directionContextExt extends AbstractBaseExt {

	public Property_lvar_port_directionContextExt(Property_lvar_port_directionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_lvar_port_directionContext getContext() {
		return (Property_lvar_port_directionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_lvar_port_direction());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_lvar_port_directionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_lvar_port_directionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}