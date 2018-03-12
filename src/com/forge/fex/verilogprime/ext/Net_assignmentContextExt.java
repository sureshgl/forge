package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_assignmentContextExt extends AbstractBaseExt {

	public Net_assignmentContextExt(Net_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_assignmentContext getContext() {
		return (Net_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Net_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}