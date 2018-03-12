package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_hashtable_identifierContext;

public class Type_hashtable_identifierContextExt extends AbstractBaseExt {

	public Type_hashtable_identifierContextExt(Type_hashtable_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_hashtable_identifierContext getContext() {
		return (Type_hashtable_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_hashtable_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_hashtable_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_hashtable_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
