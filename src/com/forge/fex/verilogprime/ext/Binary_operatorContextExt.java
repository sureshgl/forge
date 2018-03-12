package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Binary_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Binary_operatorContextExt extends AbstractBaseExt {

	public Binary_operatorContextExt(Binary_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Binary_operatorContext getContext() {
		return (Binary_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).binary_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Binary_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Binary_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}