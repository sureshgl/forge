package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LcurlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LcurlContextExt extends AbstractBaseExt {

	public LcurlContextExt(LcurlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LcurlContext getContext() {
		return (LcurlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lcurl());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LcurlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LcurlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}