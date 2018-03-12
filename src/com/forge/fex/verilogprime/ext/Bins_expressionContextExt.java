package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bins_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bins_expressionContextExt extends AbstractBaseExt {

	public Bins_expressionContextExt(Bins_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bins_expressionContext getContext() {
		return (Bins_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bins_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bins_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bins_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}