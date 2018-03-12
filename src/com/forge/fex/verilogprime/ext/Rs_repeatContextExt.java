package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rs_repeatContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rs_repeatContextExt extends AbstractBaseExt {

	public Rs_repeatContextExt(Rs_repeatContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rs_repeatContext getContext() {
		return (Rs_repeatContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rs_repeat());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rs_repeatContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rs_repeatContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}