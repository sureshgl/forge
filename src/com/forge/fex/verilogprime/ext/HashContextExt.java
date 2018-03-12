package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.HashContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class HashContextExt extends AbstractBaseExt {

	public HashContextExt(HashContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public HashContext getContext() {
		return (HashContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof HashContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + HashContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}