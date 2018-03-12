package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.InoutstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class InoutstrContextExt extends AbstractBaseExt {

	public InoutstrContextExt(InoutstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InoutstrContext getContext() {
		return (InoutstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inoutstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InoutstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InoutstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}