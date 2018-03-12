package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_bit_selectContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_bit_selectContextExt extends AbstractBaseExt {

	public Constant_bit_selectContextExt(Constant_bit_selectContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_bit_selectContext getContext() {
		return (Constant_bit_selectContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_bit_select());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_bit_selectContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_bit_selectContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}