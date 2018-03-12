package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_decl_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_decl_assignmentContextExt extends AbstractBaseExt {

	public Net_decl_assignmentContextExt(Net_decl_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_decl_assignmentContext getContext() {
		return (Net_decl_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_decl_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_decl_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Net_decl_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}