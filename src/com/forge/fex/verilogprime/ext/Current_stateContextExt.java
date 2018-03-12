package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Current_stateContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Current_stateContextExt extends AbstractBaseExt {

	public Current_stateContextExt(Current_stateContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Current_stateContext getContext() {
		return (Current_stateContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).current_state());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Current_stateContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Current_stateContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}