package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rs_ruleContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rs_ruleContextExt extends AbstractBaseExt {

	public Rs_ruleContextExt(Rs_ruleContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rs_ruleContext getContext() {
		return (Rs_ruleContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rs_rule());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rs_ruleContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rs_ruleContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}