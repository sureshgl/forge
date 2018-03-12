package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_actionContext;

public class Field_actionContextExt extends AbstractBaseExt {

	public Field_actionContextExt(Field_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_actionContext getContext() {
		return (Field_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
