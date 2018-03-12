package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Finish_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Finish_numberContextExt extends AbstractBaseExt {

	public Finish_numberContextExt(Finish_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Finish_numberContext getContext() {
		return (Finish_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).finish_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Finish_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Finish_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}