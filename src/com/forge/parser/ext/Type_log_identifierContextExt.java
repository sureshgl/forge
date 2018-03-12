package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_log_identifierContext;

public class Type_log_identifierContextExt extends AbstractBaseExt {

	public Type_log_identifierContextExt(Type_log_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_log_identifierContext getContext() {
		return (Type_log_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_log_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_log_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_log_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
