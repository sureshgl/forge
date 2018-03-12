package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hash_mapContext;

public class Hash_mapContextExt extends AbstractBaseExt {

	public Hash_mapContextExt(Hash_mapContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_mapContext getContext() {
		return (Hash_mapContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_map());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_mapContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hash_mapContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
