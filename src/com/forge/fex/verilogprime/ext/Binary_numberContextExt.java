package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Binary_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Binary_numberContextExt extends AbstractBaseExt {

	public Binary_numberContextExt(Binary_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Binary_numberContext getContext() {
		return (Binary_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).binary_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Binary_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Binary_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}