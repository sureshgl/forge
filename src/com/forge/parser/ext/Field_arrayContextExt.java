package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_arrayContext;

public class Field_arrayContextExt extends AbstractBaseExt {

	public Field_arrayContextExt(Field_arrayContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_arrayContext getContext() {
		return (Field_arrayContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_array());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_arrayContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_arrayContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
