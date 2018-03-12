package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PmosContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PmosContextExt extends AbstractBaseExt {

	public PmosContextExt(PmosContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PmosContext getContext() {
		return (PmosContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pmos());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PmosContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PmosContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}