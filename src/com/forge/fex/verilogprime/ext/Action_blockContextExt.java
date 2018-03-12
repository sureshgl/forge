package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Action_blockContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Action_blockContextExt extends AbstractBaseExt {

	public Action_blockContextExt(Action_blockContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Action_blockContext getContext() {
		return (Action_blockContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).action_block());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Action_blockContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Action_blockContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}