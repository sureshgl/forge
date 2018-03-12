package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.UnionstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class UnionstrContextExt extends AbstractBaseExt {

	public UnionstrContextExt(UnionstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public UnionstrContext getContext() {
		return (UnionstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unionstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof UnionstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + UnionstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}