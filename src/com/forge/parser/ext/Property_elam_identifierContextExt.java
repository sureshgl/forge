package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Property_elam_identifierContext;

public class Property_elam_identifierContextExt extends AbstractBaseExt {

	public Property_elam_identifierContextExt(Property_elam_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_elam_identifierContext getContext() {
		return (Property_elam_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_elam_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_elam_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Property_elam_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
