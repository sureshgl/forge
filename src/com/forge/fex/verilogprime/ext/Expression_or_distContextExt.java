package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expression_or_distContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Expression_or_distContextExt extends AbstractBaseExt {

	public Expression_or_distContextExt(Expression_or_distContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Expression_or_distContext getContext() {
		return (Expression_or_distContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).expression_or_dist());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Expression_or_distContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Expression_or_distContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}