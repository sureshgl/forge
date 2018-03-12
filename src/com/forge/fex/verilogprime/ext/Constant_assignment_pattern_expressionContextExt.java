package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_assignment_pattern_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_assignment_pattern_expressionContextExt extends AbstractBaseExt {

	public Constant_assignment_pattern_expressionContextExt(Constant_assignment_pattern_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_assignment_pattern_expressionContext getContext() {
		return (Constant_assignment_pattern_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_assignment_pattern_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_assignment_pattern_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_assignment_pattern_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}