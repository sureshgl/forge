package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NotContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NotContextExt extends AbstractBaseExt {

	public NotContextExt(NotContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NotContext getContext() {
		return (NotContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).not());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NotContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NotContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}