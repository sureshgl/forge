package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hint_zerotimeContext;

public class Hint_zerotimeContextExt extends AbstractBaseExt {

	public Hint_zerotimeContextExt(Hint_zerotimeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hint_zerotimeContext getContext() {
		return (Hint_zerotimeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hint_zerotime());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hint_zerotimeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hint_zerotimeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
