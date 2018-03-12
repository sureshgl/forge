package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Action_id_part1Context;

public class Action_id_part1ContextExt extends AbstractBaseExt {

	public Action_id_part1ContextExt(Action_id_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Action_id_part1Context getContext() {
		return (Action_id_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).action_id_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Action_id_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Action_id_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
