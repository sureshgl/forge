package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Ecc_wordsContext;

public class Ecc_wordsContextExt extends AbstractBaseExt {

	public Ecc_wordsContextExt(Ecc_wordsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ecc_wordsContext getContext() {
		return (Ecc_wordsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ecc_words());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ecc_wordsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Ecc_wordsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
