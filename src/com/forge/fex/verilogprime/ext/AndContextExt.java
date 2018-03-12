package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AndContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AndContextExt extends AbstractBaseExt {

	public AndContextExt(AndContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AndContext getContext() {
		return (AndContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).and());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AndContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AndContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}