package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dist_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dist_listContextExt extends AbstractBaseExt {

	public Dist_listContextExt(Dist_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dist_listContext getContext() {
		return (Dist_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dist_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dist_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Dist_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}