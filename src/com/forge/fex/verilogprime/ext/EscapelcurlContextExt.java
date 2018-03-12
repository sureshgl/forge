package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EscapelcurlContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EscapelcurlContextExt extends AbstractBaseExt {

	public EscapelcurlContextExt(EscapelcurlContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EscapelcurlContext getContext() {
		return (EscapelcurlContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).escapelcurl());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EscapelcurlContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EscapelcurlContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}