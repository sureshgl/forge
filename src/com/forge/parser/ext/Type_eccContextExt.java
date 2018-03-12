package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_eccContext;

public class Type_eccContextExt extends AbstractBaseExt {

	public Type_eccContextExt(Type_eccContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_eccContext getContext() {
		return (Type_eccContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_ecc());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_eccContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_eccContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
