package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.AndandandContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class AndandandContextExt extends AbstractBaseExt {

	public AndandandContextExt(AndandandContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public AndandandContext getContext() {
		return (AndandandContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).andandand());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof AndandandContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + AndandandContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}