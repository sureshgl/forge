package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Pc_Context;

public class Pc_ContextExt extends AbstractBaseExt {

	public Pc_ContextExt(Pc_Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pc_Context getContext() {
		return (Pc_Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pc_());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pc_Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Pc_Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
