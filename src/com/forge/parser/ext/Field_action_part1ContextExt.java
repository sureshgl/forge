package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_action_part1Context;

public class Field_action_part1ContextExt extends AbstractBaseExt {

	public Field_action_part1ContextExt(Field_action_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_action_part1Context getContext() {
		return (Field_action_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_action_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_action_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Field_action_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
