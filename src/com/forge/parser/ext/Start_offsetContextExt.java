package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Start_offsetContext;

public class Start_offsetContextExt extends AbstractBaseExt {

	public Start_offsetContextExt(Start_offsetContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Start_offsetContext getContext() {
		return (Start_offsetContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).start_offset());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Start_offsetContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Start_offsetContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
