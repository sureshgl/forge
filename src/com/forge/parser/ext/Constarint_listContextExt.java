package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Constarint_listContext;

public class Constarint_listContextExt extends AbstractBaseExt {

	public Constarint_listContextExt(Constarint_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constarint_listContext getContext() {
		return (Constarint_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constarint_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constarint_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constarint_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
