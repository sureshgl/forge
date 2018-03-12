package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Illegal_binsstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Illegal_binsstrContextExt extends AbstractBaseExt {

	public Illegal_binsstrContextExt(Illegal_binsstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Illegal_binsstrContext getContext() {
		return (Illegal_binsstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).illegal_binsstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Illegal_binsstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Illegal_binsstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}