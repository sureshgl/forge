package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Production_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Production_identifierContextExt extends AbstractBaseExt {

	public Production_identifierContextExt(Production_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Production_identifierContext getContext() {
		return (Production_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).production_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Production_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Production_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}