package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Random_qualifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Random_qualifierContextExt extends AbstractBaseExt {

	public Random_qualifierContextExt(Random_qualifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Random_qualifierContext getContext() {
		return (Random_qualifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).random_qualifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Random_qualifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Random_qualifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}