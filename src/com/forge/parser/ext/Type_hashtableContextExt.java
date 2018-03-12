package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_hashtableContext;

public class Type_hashtableContextExt extends AbstractBaseExt {

	public Type_hashtableContextExt(Type_hashtableContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_hashtableContext getContext() {
		return (Type_hashtableContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_hashtable());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_hashtableContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_hashtableContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
