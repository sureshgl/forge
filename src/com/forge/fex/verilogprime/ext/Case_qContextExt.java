package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_qContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_qContextExt extends AbstractBaseExt {

	public Case_qContextExt(Case_qContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_qContext getContext() {
		return (Case_qContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_q());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_qContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Case_qContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}