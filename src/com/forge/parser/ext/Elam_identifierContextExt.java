package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Elam_identifierContext;

public class Elam_identifierContextExt extends AbstractBaseExt {

	public Elam_identifierContextExt(Elam_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Elam_identifierContext getContext() {
		return (Elam_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).elam_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Elam_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Elam_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
