package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Buckets_numberContext;

public class Buckets_numberContextExt extends AbstractBaseExt {

	public Buckets_numberContextExt(Buckets_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Buckets_numberContext getContext() {
		return (Buckets_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Buckets_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Buckets_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
