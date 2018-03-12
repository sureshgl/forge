package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Pr_Context;

public class Pr_ContextExt extends AbstractBaseExt {

	public Pr_ContextExt(Pr_Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pr_Context getContext() {
		return (Pr_Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pr_());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pr_Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Pr_Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
