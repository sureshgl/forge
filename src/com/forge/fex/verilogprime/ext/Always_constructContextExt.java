package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Always_constructContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Always_constructContextExt extends AbstractBaseExt {

	public Always_constructContextExt(Always_constructContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Always_constructContext getContext() {
		return (Always_constructContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).always_construct());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Always_constructContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Always_constructContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}