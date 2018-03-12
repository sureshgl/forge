package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BitstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BitstrContextExt extends AbstractBaseExt {

	public BitstrContextExt(BitstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BitstrContext getContext() {
		return (BitstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bitstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BitstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BitstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}