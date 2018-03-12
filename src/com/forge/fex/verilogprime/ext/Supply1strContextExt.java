package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Supply1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Supply1strContextExt extends AbstractBaseExt {

	public Supply1strContextExt(Supply1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Supply1strContext getContext() {
		return (Supply1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).supply1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Supply1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Supply1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}