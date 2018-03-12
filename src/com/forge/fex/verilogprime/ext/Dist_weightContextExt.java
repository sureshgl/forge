package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dist_weightContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dist_weightContextExt extends AbstractBaseExt {

	public Dist_weightContextExt(Dist_weightContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dist_weightContext getContext() {
		return (Dist_weightContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dist_weight());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dist_weightContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Dist_weightContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}