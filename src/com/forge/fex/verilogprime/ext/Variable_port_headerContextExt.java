package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Variable_port_headerContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Variable_port_headerContextExt extends AbstractBaseExt {

	public Variable_port_headerContextExt(Variable_port_headerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Variable_port_headerContext getContext() {
		return (Variable_port_headerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).variable_port_header());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Variable_port_headerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Variable_port_headerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}