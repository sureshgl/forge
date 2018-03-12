package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bin_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bin_identifierContextExt extends AbstractBaseExt {

	public Bin_identifierContextExt(Bin_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bin_identifierContext getContext() {
		return (Bin_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bin_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bin_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bin_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}