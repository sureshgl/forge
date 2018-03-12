package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parameter_port_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Parameter_port_declarationContextExt extends AbstractBaseExt {

	public Parameter_port_declarationContextExt(Parameter_port_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_port_declarationContext getContext() {
		return (Parameter_port_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_port_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_port_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_port_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}