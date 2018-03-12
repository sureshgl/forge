package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Value_identifierContext;

public class Value_identifierContextExt extends AbstractBaseExt {

	public Value_identifierContextExt(Value_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Value_identifierContext getContext() {
		return (Value_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).value_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Value_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Value_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
