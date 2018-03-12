package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hash_typeContext;

public class Hash_typeContextExt extends AbstractBaseExt {

	public Hash_typeContextExt(Hash_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_typeContext getContext() {
		return (Hash_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hash_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
