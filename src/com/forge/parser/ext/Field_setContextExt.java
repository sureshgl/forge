package com.forge.parser.ext;

import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_setContext;

public class Field_setContextExt extends AbstractBaseExt {

	public Field_setContextExt(Field_setContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_setContext getContext() {
		return (Field_setContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_set());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_setContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_setContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		Field_setContext ctx = getContext();
		offset.set(0);
		for (int i = 0; i < ctx.field_set_properties().size(); i++) {
			getExtendedContextVisitor().visit(ctx.field_set_properties(i)).calculateFieldOffset(offset);

		}
	}
}
