package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Z_or_xContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Z_or_xContextExt extends AbstractBaseExt {

	public Z_or_xContextExt(Z_or_xContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Z_or_xContext getContext() {
		return (Z_or_xContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).z_or_x());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Z_or_xContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Z_or_xContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}