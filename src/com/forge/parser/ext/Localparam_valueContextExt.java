package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Localparam_valueContext;

public class Localparam_valueContextExt extends AbstractBaseExt {

	public Localparam_valueContextExt(Localparam_valueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Localparam_valueContext getContext() {
		return (Localparam_valueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).localparam_value());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Localparam_valueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Localparam_valueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
