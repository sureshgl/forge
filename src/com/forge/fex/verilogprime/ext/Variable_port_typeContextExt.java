package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Variable_port_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Variable_port_typeContextExt extends AbstractBaseExt {

	public Variable_port_typeContextExt(Variable_port_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Variable_port_typeContext getContext() {
		return (Variable_port_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).variable_port_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Variable_port_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Variable_port_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}