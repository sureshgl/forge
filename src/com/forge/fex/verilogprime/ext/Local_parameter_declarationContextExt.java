package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Local_parameter_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_assignmentContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Parameter_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Local_parameter_declarationContextExt extends AbstractBaseExt {

	public Local_parameter_declarationContextExt(Local_parameter_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Local_parameter_declarationContext getContext() {
		return (Local_parameter_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).local_parameter_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Local_parameter_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Local_parameter_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void populateAllParameters(Map<String, String> parameterMap) {
		Local_parameter_declarationContext ctx = getContext();
		if (ctx.data_type_or_implicit() != null && !ctx.data_type_or_implicit().getText().equals("")
				|| ctx.typestr() != null && !ctx.typestr().getText().equals("")) {
			AbstractBaseExt.L.error("Parameters have sizes. Not handled yet!");
		}
		for (Param_assignmentContext param_assignmentContext : ctx.list_of_param_assignments().param_assignment()) {
			if (param_assignmentContext.unpacked_dimension() != null
					&& param_assignmentContext.unpacked_dimension().size() > 0
					&& !param_assignmentContext.unpacked_dimension(0).getText().equals("")) {
				AbstractBaseExt.L.error("Parameters have sizes. Not handled yet!");
			} else if (param_assignmentContext.assign().size() > 1) {
				AbstractBaseExt.L.error("More than one assignment to parameter. Not handled yet!");
			} else {
				parameterMap.put(param_assignmentContext.parameter_identifier().extendedContext.getFormattedText(),
						param_assignmentContext.constant_param_expression(0).extendedContext.getFormattedText());
			}
		}
	}
	
	public void populateParametersForForgeEvaluation(Map<String, ParserRuleContext> parameterMap) {
		Local_parameter_declarationContext ctx = getContext();
		if (ctx.data_type_or_implicit() != null && !ctx.data_type_or_implicit().getText().equals("")
				|| ctx.typestr() != null && !ctx.typestr().getText().equals("")) {
			AbstractBaseExt.L.error("Parameters have sizes. Not handled yet!");
		}
		for (Param_assignmentContext param_assignmentContext : ctx.list_of_param_assignments().param_assignment()) {
			if (param_assignmentContext.unpacked_dimension() != null
					&& param_assignmentContext.unpacked_dimension().size() > 0
					&& !param_assignmentContext.unpacked_dimension(0).getText().equals("")) {
				AbstractBaseExt.L.error("Parameters have sizes. Not handled yet!");
			} else if (param_assignmentContext.assign().size() > 1) {
				AbstractBaseExt.L.error("More than one assignment to parameter. Not handled yet!");
			} else {
				parameterMap.put(param_assignmentContext.parameter_identifier().extendedContext.getFormattedText(),
						param_assignmentContext.constant_param_expression(0));
			}
		}
	}
}