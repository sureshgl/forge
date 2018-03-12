package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IffstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IffstrContextExt extends AbstractBaseExt {

	public IffstrContextExt(IffstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IffstrContext getContext() {
		return (IffstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).iffstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IffstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IffstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}