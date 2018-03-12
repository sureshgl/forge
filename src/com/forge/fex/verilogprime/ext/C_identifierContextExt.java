package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.C_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class C_identifierContextExt extends AbstractBaseExt {

	public C_identifierContextExt(C_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public C_identifierContext getContext() {
		return (C_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).c_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof C_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + C_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}