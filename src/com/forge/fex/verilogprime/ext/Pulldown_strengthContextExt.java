package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pulldown_strengthContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pulldown_strengthContextExt extends AbstractBaseExt {

	public Pulldown_strengthContextExt(Pulldown_strengthContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pulldown_strengthContext getContext() {
		return (Pulldown_strengthContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulldown_strength());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pulldown_strengthContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pulldown_strengthContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}