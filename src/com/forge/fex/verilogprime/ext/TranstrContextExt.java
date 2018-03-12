package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TranstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TranstrContextExt extends AbstractBaseExt {

	public TranstrContextExt(TranstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TranstrContext getContext() {
		return (TranstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).transtr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TranstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TranstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}