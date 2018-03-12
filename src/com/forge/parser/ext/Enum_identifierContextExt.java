package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Enum_identifierContext;

public class Enum_identifierContextExt extends AbstractBaseExt {

	public Enum_identifierContextExt(Enum_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Enum_identifierContext getContext() {
		return (Enum_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enum_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Enum_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Enum_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
