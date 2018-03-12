package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.AlignContext;

public class AlignContextExt extends AbstractBaseExt {

	public AlignContextExt(AlignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AlignContext getContext() {
		return (AlignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).align());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AlignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AlignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}