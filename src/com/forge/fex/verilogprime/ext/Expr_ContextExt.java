package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Expr_Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Expr_ContextExt extends AbstractBaseExt {

	public Expr_ContextExt(Expr_Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Expr_Context getContext() {
		return (Expr_Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).expr_());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Expr_Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Expr_Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}