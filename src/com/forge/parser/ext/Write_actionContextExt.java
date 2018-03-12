package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Write_actionContext;

public class Write_actionContextExt extends AbstractBaseExt {

	public Write_actionContextExt(Write_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Write_actionContext getContext() {
		return (Write_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).write_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Write_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Write_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
