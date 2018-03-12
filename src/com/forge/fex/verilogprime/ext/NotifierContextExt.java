package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NotifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NotifierContextExt extends AbstractBaseExt {

	public NotifierContextExt(NotifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NotifierContext getContext() {
		return (NotifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).notifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NotifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NotifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}