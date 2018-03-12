package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.For_initializationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class For_initializationContextExt extends AbstractBaseExt {

	public For_initializationContextExt(For_initializationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public For_initializationContext getContext() {
		return (For_initializationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).for_initialization());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof For_initializationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ For_initializationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}