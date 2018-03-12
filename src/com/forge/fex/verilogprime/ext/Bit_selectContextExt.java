package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bit_selectContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bit_selectContextExt extends AbstractBaseExt {

	public Bit_selectContextExt(Bit_selectContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bit_selectContext getContext() {
		return (Bit_selectContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bit_select());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bit_selectContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Bit_selectContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}