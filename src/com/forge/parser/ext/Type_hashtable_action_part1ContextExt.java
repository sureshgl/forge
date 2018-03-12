package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_hashtable_action_part1Context;

public class Type_hashtable_action_part1ContextExt extends AbstractBaseExt {

	public Type_hashtable_action_part1ContextExt(Type_hashtable_action_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_hashtable_action_part1Context getContext() {
		return (Type_hashtable_action_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_hashtable_action_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_hashtable_action_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_hashtable_action_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
