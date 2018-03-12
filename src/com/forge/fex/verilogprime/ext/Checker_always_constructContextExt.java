package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Checker_always_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Checker_always_constructContextExt extends AbstractBaseExt {

	public Checker_always_constructContextExt(Checker_always_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Checker_always_constructContext getContext() {
		return (Checker_always_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checker_always_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Checker_always_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Checker_always_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}