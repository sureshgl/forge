package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_param_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_param_expressionContextExt extends AbstractBaseExt {

	public Constant_param_expressionContextExt(Constant_param_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_param_expressionContext getContext() {
		return (Constant_param_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_param_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_param_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_param_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}