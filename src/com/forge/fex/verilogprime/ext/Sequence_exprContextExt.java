package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_exprContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_exprContextExt extends AbstractBaseExt {

	public Sequence_exprContextExt(Sequence_exprContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_exprContext getContext() {
		return (Sequence_exprContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_expr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_exprContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Sequence_exprContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}