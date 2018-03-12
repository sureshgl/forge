package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Supply0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Supply0strContextExt extends AbstractBaseExt {

	public Supply0strContextExt(Supply0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Supply0strContext getContext() {
		return (Supply0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).supply0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Supply0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Supply0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}