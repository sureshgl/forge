package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Repeater_identifierContext;

public class Repeater_identifierContextExt extends AbstractBaseExt {

	public Repeater_identifierContextExt(Repeater_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Repeater_identifierContext getContext() {
		return (Repeater_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).repeater_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Repeater_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Repeater_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
