package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Ecc_actionContext;

public class Ecc_actionContextExt extends AbstractBaseExt {

	public Ecc_actionContextExt(Ecc_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ecc_actionContext getContext() {
		return (Ecc_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ecc_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ecc_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Ecc_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
