package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StringstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StringstrContextExt extends AbstractBaseExt {

	public StringstrContextExt(StringstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StringstrContext getContext() {
		return (StringstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).stringstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StringstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StringstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}