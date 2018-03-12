package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Reject_limit_valueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Reject_limit_valueContextExt extends AbstractBaseExt {

	public Reject_limit_valueContextExt(Reject_limit_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Reject_limit_valueContext getContext() {
		return (Reject_limit_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).reject_limit_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Reject_limit_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Reject_limit_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}