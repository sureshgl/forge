package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StargtContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StargtContextExt extends AbstractBaseExt {

	public StargtContextExt(StargtContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StargtContext getContext() {
		return (StargtContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).stargt());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StargtContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StargtContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}