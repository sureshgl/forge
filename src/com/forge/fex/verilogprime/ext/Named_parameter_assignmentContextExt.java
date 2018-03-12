package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Named_parameter_assignmentContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Named_parameter_assignmentContextExt extends AbstractBaseExt {

	public Named_parameter_assignmentContextExt(Named_parameter_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Named_parameter_assignmentContext getContext() {
		return (Named_parameter_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).named_parameter_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Named_parameter_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Named_parameter_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void collectDeclaredParameterConnections(Map<String, Param_expressionContext> parameters) {
		Named_parameter_assignmentContext ctx = getContext();
		String name = ctx.parameter_identifier().extendedContext.getFormattedText();
		if (ctx.param_expression() != null) {
			parameters.put(name, ctx.param_expression());
		} else {
			parameters.put(name, null);
		}
	}
}
