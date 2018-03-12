package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarskewstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarskewstrContextExt extends AbstractBaseExt {

	public DollarskewstrContextExt(DollarskewstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarskewstrContext getContext() {
		return (DollarskewstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarskewstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarskewstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarskewstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}