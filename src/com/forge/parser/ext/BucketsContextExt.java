package com.forge.parser.ext;

import java.util.HashMap;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.BucketsContext;

public class BucketsContextExt extends AbstractBaseExt {

	public BucketsContextExt(BucketsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BucketsContext getContext() {
		return (BucketsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BucketsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BucketsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		BucketsContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("buckets")) {
				propStore.put("buckets", ctx.buckets_number().extendedContext.getFormattedText());
			} else {
				throw new IllegalStateException("Buckets" + " is duplicated in " + propStore.get("propName")
						+ " in line " + ctx.start.getLine());
			}
		}
	}
}
