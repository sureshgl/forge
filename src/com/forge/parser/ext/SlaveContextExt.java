package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.SlaveContext;

public class SlaveContextExt extends AbstractBaseExt {

	public SlaveContextExt(SlaveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SlaveContext getContext() {
		return (SlaveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).slave());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SlaveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SlaveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
