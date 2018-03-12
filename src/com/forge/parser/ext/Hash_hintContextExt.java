package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hash_hintContext;

public class Hash_hintContextExt extends AbstractBaseExt {

	public Hash_hintContextExt(Hash_hintContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_hintContext getContext() {
		return (Hash_hintContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_hint());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_hintContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hash_hintContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
