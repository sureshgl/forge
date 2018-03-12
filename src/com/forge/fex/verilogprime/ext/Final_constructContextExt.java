package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Final_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Final_constructContextExt extends AbstractBaseExt {

	public Final_constructContextExt(Final_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Final_constructContext getContext() {
		return (Final_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).final_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Final_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Final_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}