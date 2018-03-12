package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pullup_strengthContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pullup_strengthContextExt extends AbstractBaseExt {

	public Pullup_strengthContextExt(Pullup_strengthContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pullup_strengthContext getContext() {
		return (Pullup_strengthContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pullup_strength());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pullup_strengthContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pullup_strengthContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}