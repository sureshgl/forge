package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.AttributesContext;

public class AttributesContextExt extends AbstractBaseExt {

	public AttributesContextExt(AttributesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AttributesContext getContext() {
		return (AttributesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attributes());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AttributesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AttributesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
