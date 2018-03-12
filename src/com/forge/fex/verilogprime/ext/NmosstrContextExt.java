package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NmosstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NmosstrContextExt extends AbstractBaseExt {

	public NmosstrContextExt(NmosstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NmosstrContext getContext() {
		return (NmosstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nmosstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NmosstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NmosstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}