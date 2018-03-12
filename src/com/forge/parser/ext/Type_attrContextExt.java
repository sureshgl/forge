package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_attrContext;

public class Type_attrContextExt extends AbstractBaseExt {

	public Type_attrContextExt(Type_attrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_attrContext getContext() {
		return (Type_attrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_attr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_attrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_attrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
