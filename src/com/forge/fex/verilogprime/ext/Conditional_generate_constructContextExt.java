package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Conditional_generate_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Conditional_generate_constructContextExt extends AbstractBaseExt {

	public Conditional_generate_constructContextExt(Conditional_generate_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Conditional_generate_constructContext getContext() {
		return (Conditional_generate_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).conditional_generate_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Conditional_generate_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Conditional_generate_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}