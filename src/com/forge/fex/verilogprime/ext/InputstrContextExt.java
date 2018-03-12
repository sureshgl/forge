package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.InputstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class InputstrContextExt extends AbstractBaseExt {

	public InputstrContextExt(InputstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InputstrContext getContext() {
		return (InputstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inputstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InputstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InputstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isInput() {
		return true;
	}
}