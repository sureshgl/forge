package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Param_expressionContextExt extends AbstractBaseExt {

	public Param_expressionContextExt(Param_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Param_expressionContext getContext() {
		return (Param_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).param_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Param_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Param_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}