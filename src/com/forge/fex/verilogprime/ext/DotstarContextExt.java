package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DotstarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DotstarContextExt extends AbstractBaseExt {

	public DotstarContextExt(DotstarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DotstarContext getContext() {
		return (DotstarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dotstar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DotstarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DotstarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}