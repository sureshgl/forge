package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inc_or_dec_expression_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inc_or_dec_expression_part1ContextExt extends AbstractBaseExt {

	public Inc_or_dec_expression_part1ContextExt(Inc_or_dec_expression_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inc_or_dec_expression_part1Context getContext() {
		return (Inc_or_dec_expression_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inc_or_dec_expression_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inc_or_dec_expression_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Inc_or_dec_expression_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}