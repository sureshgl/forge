package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EscapequoteContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EscapequoteContextExt extends AbstractBaseExt {

	public EscapequoteContextExt(EscapequoteContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EscapequoteContext getContext() {
		return (EscapequoteContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).escapequote());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EscapequoteContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EscapequoteContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}