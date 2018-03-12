package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hint_memogenContext;


public class Hint_memogenContextExt extends AbstractBaseExt {

	public Hint_memogenContextExt(Hint_memogenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hint_memogenContext getContext() {
		return (Hint_memogenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hint_memogen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hint_memogenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hint_memogenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
