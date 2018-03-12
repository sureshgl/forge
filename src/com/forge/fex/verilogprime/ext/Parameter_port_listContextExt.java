package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parameter_port_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Parameter_port_listContextExt extends AbstractBaseExt {

	public Parameter_port_listContextExt(Parameter_port_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_port_listContext getContext() {
		return (Parameter_port_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_port_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_port_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_port_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}