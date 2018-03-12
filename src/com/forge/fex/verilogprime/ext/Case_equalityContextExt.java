package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_equalityContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_equalityContextExt extends AbstractBaseExt {

	public Case_equalityContextExt(Case_equalityContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_equalityContext getContext() {
		return (Case_equalityContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_equality());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_equalityContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Case_equalityContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}