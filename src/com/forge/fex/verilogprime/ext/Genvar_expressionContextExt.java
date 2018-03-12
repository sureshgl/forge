package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Genvar_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Genvar_expressionContextExt extends AbstractBaseExt {

	public Genvar_expressionContextExt(Genvar_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Genvar_expressionContext getContext() {
		return (Genvar_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvar_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Genvar_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Genvar_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}