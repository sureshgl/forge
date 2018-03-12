package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Join_keywordContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Join_keywordContextExt extends AbstractBaseExt {

	public Join_keywordContextExt(Join_keywordContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Join_keywordContext getContext() {
		return (Join_keywordContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).join_keyword());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Join_keywordContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Join_keywordContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}