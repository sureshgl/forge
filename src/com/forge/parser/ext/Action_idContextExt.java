package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Action_idContext;

public class Action_idContextExt extends AbstractBaseExt {

	public Action_idContextExt(Action_idContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Action_idContext getContext() {
		return (Action_idContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).action_id());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Action_idContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Action_idContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
