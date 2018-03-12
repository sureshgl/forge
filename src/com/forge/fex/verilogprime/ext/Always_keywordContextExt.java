package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Always_keywordContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Always_keywordContextExt extends AbstractBaseExt {

	public Always_keywordContextExt(Always_keywordContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Always_keywordContext getContext() {
		return (Always_keywordContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).always_keyword());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Always_keywordContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Always_keywordContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}