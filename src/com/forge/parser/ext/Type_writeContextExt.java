package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_writeContext;

public class Type_writeContextExt extends AbstractBaseExt {

	public Type_writeContextExt(Type_writeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_writeContext getContext() {
		return (Type_writeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_write());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_writeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_writeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
