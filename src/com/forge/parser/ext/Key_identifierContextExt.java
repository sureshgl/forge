package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Key_identifierContext;

public class Key_identifierContextExt extends AbstractBaseExt {

	public Key_identifierContextExt(Key_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Key_identifierContext getContext() {
		return (Key_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).key_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Key_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Key_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
