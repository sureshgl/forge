package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndtablestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndtablestrContextExt extends AbstractBaseExt {

	public EndtablestrContextExt(EndtablestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndtablestrContext getContext() {
		return (EndtablestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endtablestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndtablestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndtablestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}