package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Trigger_identifierContext;

public class Trigger_identifierContextExt extends AbstractBaseExt {

	public Trigger_identifierContextExt(Trigger_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Trigger_identifierContext getContext() {
		return (Trigger_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trigger_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Trigger_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Trigger_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
