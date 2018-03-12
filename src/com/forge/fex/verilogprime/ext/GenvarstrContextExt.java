package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.GenvarstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class GenvarstrContextExt extends AbstractBaseExt {

	public GenvarstrContextExt(GenvarstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public GenvarstrContext getContext() {
		return (GenvarstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).genvarstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof GenvarstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + GenvarstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}