package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Banks_sizeContext;

public class Banks_sizeContextExt extends AbstractBaseExt {

	public Banks_sizeContextExt(Banks_sizeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Banks_sizeContext getContext() {
		return (Banks_sizeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).banks_size());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Banks_sizeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Banks_sizeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public Boolean hasBanksInMemory() {
		return true;
	}
}
