package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ArrayContext;

public class ArrayContextExt extends AbstractBaseExt {

	public ArrayContextExt(ArrayContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ArrayContext getContext() {
		return (ArrayContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).array());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ArrayContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ArrayContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void arrayPropertyCheck(String parentName) {
		ArrayContext ctx = getContext();
		if (Integer.parseInt(ctx.max_size().extendedContext.getFormattedText()) < Integer.parseInt(ctx.min_size().extendedContext.getFormattedText())) {
			throw new IllegalStateException(
					parentName + " has max value less than min value at line number " + ctx.start.getLine());
		}
	}
}
