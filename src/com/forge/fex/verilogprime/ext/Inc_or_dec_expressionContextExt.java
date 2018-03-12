package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inc_or_dec_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inc_or_dec_expressionContextExt extends AbstractBaseExt {

	public Inc_or_dec_expressionContextExt(Inc_or_dec_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inc_or_dec_expressionContext getContext() {
		return (Inc_or_dec_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inc_or_dec_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inc_or_dec_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Inc_or_dec_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}