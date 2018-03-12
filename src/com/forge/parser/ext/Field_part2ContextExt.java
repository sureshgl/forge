package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Field_part2Context;

public class Field_part2ContextExt extends AbstractBaseExt {

	public Field_part2ContextExt(Field_part2Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Field_part2Context getContext() {
		return (Field_part2Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).field_part2());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Field_part2Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Field_part2Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
