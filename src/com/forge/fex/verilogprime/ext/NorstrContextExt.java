package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NorstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NorstrContextExt extends AbstractBaseExt {

	public NorstrContextExt(NorstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NorstrContext getContext() {
		return (NorstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).norstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NorstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NorstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}