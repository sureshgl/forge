package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Port_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Port_expressionContextExt extends AbstractBaseExt {

	public Port_expressionContextExt(Port_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_expressionContext getContext() {
		return (Port_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}