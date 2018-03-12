package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Case_generate_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Case_generate_constructContextExt extends AbstractBaseExt {

	public Case_generate_constructContextExt(Case_generate_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Case_generate_constructContext getContext() {
		return (Case_generate_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).case_generate_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Case_generate_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Case_generate_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}