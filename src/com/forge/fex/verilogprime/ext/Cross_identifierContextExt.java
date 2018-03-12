package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cross_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cross_identifierContextExt extends AbstractBaseExt {

	public Cross_identifierContextExt(Cross_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cross_identifierContext getContext() {
		return (Cross_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cross_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cross_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cross_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}