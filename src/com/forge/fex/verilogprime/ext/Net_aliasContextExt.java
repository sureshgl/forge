package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_aliasContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_aliasContextExt extends AbstractBaseExt {

	public Net_aliasContextExt(Net_aliasContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_aliasContext getContext() {
		return (Net_aliasContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_alias());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_aliasContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Net_aliasContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}