package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_lvalueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Net_lvalueContextExt extends AbstractBaseExt {

	public Net_lvalueContextExt(Net_lvalueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Net_lvalueContext getContext() {
		return (Net_lvalueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).net_lvalue());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Net_lvalueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Net_lvalueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}