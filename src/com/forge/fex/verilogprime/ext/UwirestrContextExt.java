package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UwirestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UwirestrContextExt extends AbstractBaseExt {

	public UwirestrContextExt(UwirestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UwirestrContext getContext() {
		return (UwirestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).uwirestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UwirestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UwirestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}