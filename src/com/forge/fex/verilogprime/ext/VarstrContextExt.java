package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.VarstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class VarstrContextExt extends AbstractBaseExt {

	public VarstrContextExt(VarstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public VarstrContext getContext() {
		return (VarstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).varstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof VarstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + VarstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}