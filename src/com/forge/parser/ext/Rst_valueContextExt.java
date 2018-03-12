package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Rst_valueContext;

public class Rst_valueContextExt extends AbstractBaseExt {

	public Rst_valueContextExt(Rst_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rst_valueContext getContext() {
		return (Rst_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rst_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rst_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Rst_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
