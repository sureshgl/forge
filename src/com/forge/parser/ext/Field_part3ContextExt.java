package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_part3Context;

public class Field_part3ContextExt extends AbstractBaseExt {

	public Field_part3ContextExt(Field_part3Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_part3Context getContext() {
		return (Field_part3Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_part3());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_part3Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_part3Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
