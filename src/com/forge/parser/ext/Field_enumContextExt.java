package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_enumContext;

public class Field_enumContextExt extends AbstractBaseExt {

	public Field_enumContextExt(Field_enumContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_enumContext getContext() {
		return (Field_enumContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_enum());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_enumContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_enumContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
