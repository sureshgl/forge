package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SelectContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SelectContextExt extends AbstractBaseExt {

	public SelectContextExt(SelectContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SelectContext getContext() {
		return (SelectContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).select());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SelectContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SelectContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}