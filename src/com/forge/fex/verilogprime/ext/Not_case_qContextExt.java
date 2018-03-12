package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Not_case_qContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Not_case_qContextExt extends AbstractBaseExt {

	public Not_case_qContextExt(Not_case_qContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Not_case_qContext getContext() {
		return (Not_case_qContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).not_case_q());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Not_case_qContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Not_case_qContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}