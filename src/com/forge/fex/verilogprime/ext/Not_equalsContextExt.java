package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Not_equalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Not_equalsContextExt extends AbstractBaseExt {

	public Not_equalsContextExt(Not_equalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Not_equalsContext getContext() {
		return (Not_equalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).not_equals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Not_equalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Not_equalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}