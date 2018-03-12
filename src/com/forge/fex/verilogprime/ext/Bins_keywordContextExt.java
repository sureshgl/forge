package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bins_keywordContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bins_keywordContextExt extends AbstractBaseExt {

	public Bins_keywordContextExt(Bins_keywordContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bins_keywordContext getContext() {
		return (Bins_keywordContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bins_keyword());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bins_keywordContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Bins_keywordContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}