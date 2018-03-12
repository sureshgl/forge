package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.GeneratestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class GeneratestrContextExt extends AbstractBaseExt {

	public GeneratestrContextExt(GeneratestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public GeneratestrContext getContext() {
		return (GeneratestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).generatestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof GeneratestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + GeneratestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}