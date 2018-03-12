package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ElsestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ElsestrContextExt extends AbstractBaseExt {

	public ElsestrContextExt(ElsestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ElsestrContext getContext() {
		return (ElsestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).elsestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ElsestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ElsestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}