package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.VirtualstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class VirtualstrContextExt extends AbstractBaseExt {

	public VirtualstrContextExt(VirtualstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public VirtualstrContext getContext() {
		return (VirtualstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).virtualstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof VirtualstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + VirtualstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}