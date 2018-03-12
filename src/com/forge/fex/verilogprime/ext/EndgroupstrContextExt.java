package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndgroupstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndgroupstrContextExt extends AbstractBaseExt {

	public EndgroupstrContextExt(EndgroupstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndgroupstrContext getContext() {
		return (EndgroupstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endgroupstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndgroupstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndgroupstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}