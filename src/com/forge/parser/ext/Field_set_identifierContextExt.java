package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_set_identifierContext;

public class Field_set_identifierContextExt extends AbstractBaseExt {

	public Field_set_identifierContextExt(Field_set_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_set_identifierContext getContext() {
		return (Field_set_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_set_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_set_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Field_set_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
