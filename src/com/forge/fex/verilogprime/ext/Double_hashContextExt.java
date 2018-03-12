package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Double_hashContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Double_hashContextExt extends AbstractBaseExt {

	public Double_hashContextExt(Double_hashContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Double_hashContext getContext() {
		return (Double_hashContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).double_hash());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Double_hashContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Double_hashContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}