package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PrtContext;

public class PrtContextExt extends AbstractBaseExt {

	public PrtContextExt(PrtContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PrtContext getContext() {
		return (PrtContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).prt());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PrtContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PrtContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
