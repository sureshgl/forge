package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ChainContext;

public class ChainContextExt extends AbstractBaseExt {

	public ChainContextExt(ChainContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ChainContext getContext() {
		return (ChainContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).chain());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ChainContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ ChainContextExt.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

}
