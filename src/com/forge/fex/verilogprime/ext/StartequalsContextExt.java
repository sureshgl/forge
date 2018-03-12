package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StartequalsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StartequalsContextExt extends AbstractBaseExt {

	public StartequalsContextExt(StartequalsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StartequalsContext getContext() {
		return (StartequalsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).startequals());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StartequalsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StartequalsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}