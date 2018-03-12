package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Description_attrContext;

public class Description_attrContextExt extends AbstractBaseExt {

	public Description_attrContextExt(Description_attrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Description_attrContext getContext() {
		return (Description_attrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).description_attr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Description_attrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Description_attrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
