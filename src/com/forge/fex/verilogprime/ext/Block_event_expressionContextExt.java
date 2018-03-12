package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Block_event_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Block_event_expressionContextExt extends AbstractBaseExt {

	public Block_event_expressionContextExt(Block_event_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Block_event_expressionContext getContext() {
		return (Block_event_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).block_event_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Block_event_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Block_event_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}