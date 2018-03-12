package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_inequalityContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_inequalityContextExt extends AbstractBaseExt {

	public Case_inequalityContextExt(Case_inequalityContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_inequalityContext getContext() {
		return (Case_inequalityContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_inequality());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_inequalityContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Case_inequalityContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}