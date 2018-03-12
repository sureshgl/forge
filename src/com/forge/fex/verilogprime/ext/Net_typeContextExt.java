package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_typeContextExt extends AbstractBaseExt {

	public Net_typeContextExt(Net_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_typeContext getContext() {
		return (Net_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Net_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}