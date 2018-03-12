package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AssumestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AssumestrContextExt extends AbstractBaseExt {

	public AssumestrContextExt(AssumestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AssumestrContext getContext() {
		return (AssumestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assumestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AssumestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AssumestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}