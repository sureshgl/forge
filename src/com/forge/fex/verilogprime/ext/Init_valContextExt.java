package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Init_valContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Init_valContextExt extends AbstractBaseExt {

	public Init_valContextExt(Init_valContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Init_valContext getContext() {
		return (Init_valContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).init_val());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Init_valContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Init_valContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}