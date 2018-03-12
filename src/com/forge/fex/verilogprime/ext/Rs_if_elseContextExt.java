package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rs_if_elseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rs_if_elseContextExt extends AbstractBaseExt {

	public Rs_if_elseContextExt(Rs_if_elseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rs_if_elseContext getContext() {
		return (Rs_if_elseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rs_if_else());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rs_if_elseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rs_if_elseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}