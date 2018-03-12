package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hash_map_integerContext;

public class Hash_map_integerContextExt extends AbstractBaseExt {

	public Hash_map_integerContextExt(Hash_map_integerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_map_integerContext getContext() {
		return (Hash_map_integerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_map_integer());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_map_integerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hash_map_integerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
