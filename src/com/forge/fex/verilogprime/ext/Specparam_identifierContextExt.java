package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Specparam_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Specparam_identifierContextExt extends AbstractBaseExt {

	public Specparam_identifierContextExt(Specparam_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Specparam_identifierContext getContext() {
		return (Specparam_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).specparam_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Specparam_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Specparam_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}