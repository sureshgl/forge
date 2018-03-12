package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RbrackContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RbrackContextExt extends AbstractBaseExt {

	public RbrackContextExt(RbrackContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RbrackContext getContext() {
		return (RbrackContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rbrack());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RbrackContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RbrackContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}