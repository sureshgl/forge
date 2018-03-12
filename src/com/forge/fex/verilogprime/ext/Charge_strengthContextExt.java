package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Charge_strengthContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Charge_strengthContextExt extends AbstractBaseExt {

	public Charge_strengthContextExt(Charge_strengthContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Charge_strengthContext getContext() {
		return (Charge_strengthContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).charge_strength());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Charge_strengthContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Charge_strengthContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}