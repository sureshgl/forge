package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hash_map_descriptionContext;

public class Hash_map_descriptionContextExt extends AbstractBaseExt {

	public Hash_map_descriptionContextExt(Hash_map_descriptionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_map_descriptionContext getContext() {
		return (Hash_map_descriptionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_map_description());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_map_descriptionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hash_map_descriptionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
