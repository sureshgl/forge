package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_enumContext;

public class Type_enumContextExt extends AbstractBaseExt {

	public Type_enumContextExt(Type_enumContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_enumContext getContext() {
		return (Type_enumContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_enum());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_enumContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_enumContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
