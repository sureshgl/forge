package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ArshiftContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ArshiftContextExt extends AbstractBaseExt {

	public ArshiftContextExt(ArshiftContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ArshiftContext getContext() {
		return (ArshiftContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).arshift());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ArshiftContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ArshiftContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}