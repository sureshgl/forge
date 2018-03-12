package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Empty_queueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Empty_queueContextExt extends AbstractBaseExt {

	public Empty_queueContextExt(Empty_queueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Empty_queueContext getContext() {
		return (Empty_queueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).empty_queue());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Empty_queueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Empty_queueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}