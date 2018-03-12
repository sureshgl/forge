package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollaewidthstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollaewidthstrContextExt extends AbstractBaseExt {

	public DollaewidthstrContextExt(DollaewidthstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollaewidthstrContext getContext() {
		return (DollaewidthstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollaewidthstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollaewidthstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollaewidthstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}