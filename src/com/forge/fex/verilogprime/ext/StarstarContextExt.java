package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StarstarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StarstarContextExt extends AbstractBaseExt {

	public StarstarContextExt(StarstarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StarstarContext getContext() {
		return (StarstarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).starstar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StarstarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StarstarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}