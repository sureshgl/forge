package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PcContext;

public class PcContextExt extends AbstractBaseExt {

	public PcContextExt(PcContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PcContext getContext() {
		return (PcContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pc());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PcContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PcContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
