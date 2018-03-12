package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ProtectedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ProtectedstrContextExt extends AbstractBaseExt {

	public ProtectedstrContextExt(ProtectedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ProtectedstrContext getContext() {
		return (ProtectedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).protectedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ProtectedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ProtectedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}