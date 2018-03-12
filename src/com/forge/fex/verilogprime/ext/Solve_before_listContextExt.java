package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Solve_before_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Solve_before_listContextExt extends AbstractBaseExt {

	public Solve_before_listContextExt(Solve_before_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Solve_before_listContext getContext() {
		return (Solve_before_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).solve_before_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Solve_before_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Solve_before_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}