package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_pattern_expression_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_pattern_expression_typeContextExt extends AbstractBaseExt {

	public Assignment_pattern_expression_typeContextExt(Assignment_pattern_expression_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_pattern_expression_typeContext getContext() {
		return (Assignment_pattern_expression_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_pattern_expression_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_pattern_expression_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_pattern_expression_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}