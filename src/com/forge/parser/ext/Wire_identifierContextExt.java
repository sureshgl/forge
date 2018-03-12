package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Wire_identifierContext;

public class Wire_identifierContextExt extends AbstractBaseExt {

	public Wire_identifierContextExt(Wire_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Wire_identifierContext getContext() {
		return (Wire_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wire_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Wire_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Wire_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
