package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_logContext;

public class Type_logContextExt extends AbstractBaseExt {

	public Type_logContextExt(Type_logContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_logContext getContext() {
		return (Type_logContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_log());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_logContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_logContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
