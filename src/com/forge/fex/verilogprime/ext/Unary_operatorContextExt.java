package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unary_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unary_operatorContextExt extends AbstractBaseExt {

	public Unary_operatorContextExt(Unary_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unary_operatorContext getContext() {
		return (Unary_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unary_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unary_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unary_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}