package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.For_step_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class For_step_assignmentContextExt extends AbstractBaseExt {

	public For_step_assignmentContextExt(For_step_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public For_step_assignmentContext getContext() {
		return (For_step_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).for_step_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof For_step_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ For_step_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}