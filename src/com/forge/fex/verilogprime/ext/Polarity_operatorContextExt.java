package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Polarity_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Polarity_operatorContextExt extends AbstractBaseExt {

	public Polarity_operatorContextExt(Polarity_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Polarity_operatorContext getContext() {
		return (Polarity_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).polarity_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Polarity_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Polarity_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}