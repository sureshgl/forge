package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Write_attrContext;

public class Write_attrContextExt extends AbstractBaseExt {

	public Write_attrContextExt(Write_attrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Write_attrContext getContext() {
		return (Write_attrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).write_attr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Write_attrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Write_attrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
