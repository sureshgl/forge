package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.InterfacestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class InterfacestrContextExt extends AbstractBaseExt {

	public InterfacestrContextExt(InterfacestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public InterfacestrContext getContext() {
		return (InterfacestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).interfacestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof InterfacestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + InterfacestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}