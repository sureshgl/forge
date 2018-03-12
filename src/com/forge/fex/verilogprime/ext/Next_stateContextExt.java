package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Next_stateContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Next_stateContextExt extends AbstractBaseExt {

	public Next_stateContextExt(Next_stateContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Next_stateContext getContext() {
		return (Next_stateContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).next_state());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Next_stateContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Next_stateContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}