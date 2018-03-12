package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hex_numberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hex_numberContextExt extends AbstractBaseExt {

	public Hex_numberContextExt(Hex_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hex_numberContext getContext() {
		return (Hex_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hex_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hex_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hex_numberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}