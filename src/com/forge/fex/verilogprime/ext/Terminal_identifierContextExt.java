package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Terminal_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Terminal_identifierContextExt extends AbstractBaseExt {

	public Terminal_identifierContextExt(Terminal_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Terminal_identifierContext getContext() {
		return (Terminal_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).terminal_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Terminal_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Terminal_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}