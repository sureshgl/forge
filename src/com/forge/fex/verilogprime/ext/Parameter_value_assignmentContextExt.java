package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parameter_value_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Parameter_value_assignmentContextExt extends AbstractBaseExt {

	public Parameter_value_assignmentContextExt(Parameter_value_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Parameter_value_assignmentContext getContext() {
		return (Parameter_value_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).parameter_value_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Parameter_value_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Parameter_value_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}