package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Initial_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Initial_constructContextExt extends AbstractBaseExt {

	public Initial_constructContextExt(Initial_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Initial_constructContext getContext() {
		return (Initial_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).initial_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Initial_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Initial_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}