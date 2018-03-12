package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.SuperstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class SuperstrContextExt extends AbstractBaseExt {

	public SuperstrContextExt(SuperstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public SuperstrContext getContext() {
		return (SuperstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).superstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof SuperstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + SuperstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}