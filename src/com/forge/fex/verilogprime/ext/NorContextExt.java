package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NorContextExt extends AbstractBaseExt {

	public NorContextExt(NorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NorContext getContext() {
		return (NorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nor());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}