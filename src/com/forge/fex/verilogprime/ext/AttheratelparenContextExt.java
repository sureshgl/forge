package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AttheratelparenContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AttheratelparenContextExt extends AbstractBaseExt {

	public AttheratelparenContextExt(AttheratelparenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AttheratelparenContext getContext() {
		return (AttheratelparenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attheratelparen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AttheratelparenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ AttheratelparenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}