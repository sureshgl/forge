package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_readContext;

public class Type_readContextExt extends AbstractBaseExt {

	public Type_readContextExt(Type_readContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_readContext getContext() {
		return (Type_readContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_read());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_readContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_readContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
