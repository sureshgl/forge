package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AssertstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AssertstrContextExt extends AbstractBaseExt {

	public AssertstrContextExt(AssertstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AssertstrContext getContext() {
		return (AssertstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assertstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AssertstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AssertstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}