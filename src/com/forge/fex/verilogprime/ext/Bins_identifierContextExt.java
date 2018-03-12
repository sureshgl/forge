package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bins_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bins_identifierContextExt extends AbstractBaseExt {

	public Bins_identifierContextExt(Bins_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bins_identifierContext getContext() {
		return (Bins_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bins_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bins_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bins_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}