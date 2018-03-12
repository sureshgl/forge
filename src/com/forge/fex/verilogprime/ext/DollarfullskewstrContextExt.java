package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarfullskewstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarfullskewstrContextExt extends AbstractBaseExt {

	public DollarfullskewstrContextExt(DollarfullskewstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarfullskewstrContext getContext() {
		return (DollarfullskewstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarfullskewstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarfullskewstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarfullskewstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}