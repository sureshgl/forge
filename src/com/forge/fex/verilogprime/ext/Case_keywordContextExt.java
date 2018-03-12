package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_keywordContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_keywordContextExt extends AbstractBaseExt {

	public Case_keywordContextExt(Case_keywordContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_keywordContext getContext() {
		return (Case_keywordContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_keyword());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_keywordContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Case_keywordContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}