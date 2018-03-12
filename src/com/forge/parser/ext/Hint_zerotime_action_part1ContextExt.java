package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hint_zerotime_action_part1Context;

public class Hint_zerotime_action_part1ContextExt extends AbstractBaseExt {

	public Hint_zerotime_action_part1ContextExt(Hint_zerotime_action_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hint_zerotime_action_part1Context getContext() {
		return (Hint_zerotime_action_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hint_zerotime_action_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hint_zerotime_action_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hint_zerotime_action_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
