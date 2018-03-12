package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_pattern_variable_lvalueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_pattern_variable_lvalueContextExt extends AbstractBaseExt {

	public Assignment_pattern_variable_lvalueContextExt(Assignment_pattern_variable_lvalueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_pattern_variable_lvalueContext getContext() {
		return (Assignment_pattern_variable_lvalueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_pattern_variable_lvalue());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_pattern_variable_lvalueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_pattern_variable_lvalueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}