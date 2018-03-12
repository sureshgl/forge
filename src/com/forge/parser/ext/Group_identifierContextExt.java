package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Group_identifierContext;

public class Group_identifierContextExt extends AbstractBaseExt {

	public Group_identifierContextExt(Group_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Group_identifierContext getContext() {
		return (Group_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).group_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Group_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Group_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
