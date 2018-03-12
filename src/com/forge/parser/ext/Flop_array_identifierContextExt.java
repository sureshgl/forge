package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Flop_array_identifierContext;

public class Flop_array_identifierContextExt extends AbstractBaseExt {

	public Flop_array_identifierContextExt(Flop_array_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Flop_array_identifierContext getContext() {
		return (Flop_array_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).flop_array_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Flop_array_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Flop_array_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
