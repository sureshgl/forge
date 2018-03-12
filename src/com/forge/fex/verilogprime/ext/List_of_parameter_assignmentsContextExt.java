package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_parameter_assignmentsContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_parameter_assignmentsContextExt extends AbstractBaseExt {

	public List_of_parameter_assignmentsContextExt(List_of_parameter_assignmentsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_parameter_assignmentsContext getContext() {
		return (List_of_parameter_assignmentsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_parameter_assignments());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_parameter_assignmentsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_parameter_assignmentsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void collectDeclaredParameterConnections(Map<String, Param_expressionContext> parameters) {
		List_of_parameter_assignmentsContext ctx = getContext();
		if (ctx.ordered_parameter_assignment() != null && ctx.ordered_parameter_assignment().size() > 0) {
			AbstractBaseExt.L.error(" Ordered parameter connections encountered. Not Supported yet!");
		} else {
			super.collectDeclaredParameterConnections(parameters);
		}
	}
}