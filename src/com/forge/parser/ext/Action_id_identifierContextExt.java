package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Action_id_identifierContext;

public class Action_id_identifierContextExt extends AbstractBaseExt {

	public Action_id_identifierContextExt(Action_id_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Action_id_identifierContext getContext() {
		return (Action_id_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).action_id_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Action_id_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Action_id_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
