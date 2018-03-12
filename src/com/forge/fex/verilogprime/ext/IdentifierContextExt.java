package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IdentifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IdentifierContextExt extends AbstractBaseExt {

	public IdentifierContextExt(IdentifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IdentifierContext getContext() {
		return (IdentifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IdentifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IdentifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}