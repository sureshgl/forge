package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Defparam_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Defparam_assignmentContextExt extends AbstractBaseExt {

	public Defparam_assignmentContextExt(Defparam_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Defparam_assignmentContext getContext() {
		return (Defparam_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).defparam_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Defparam_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Defparam_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}