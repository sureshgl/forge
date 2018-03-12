package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Decimal_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Decimal_numberContextExt extends AbstractBaseExt {

	public Decimal_numberContextExt(Decimal_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Decimal_numberContext getContext() {
		return (Decimal_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).decimal_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Decimal_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Decimal_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}