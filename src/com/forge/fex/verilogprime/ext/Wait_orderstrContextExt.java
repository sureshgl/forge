package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Wait_orderstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Wait_orderstrContextExt extends AbstractBaseExt {

	public Wait_orderstrContextExt(Wait_orderstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Wait_orderstrContext getContext() {
		return (Wait_orderstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wait_orderstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Wait_orderstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Wait_orderstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}