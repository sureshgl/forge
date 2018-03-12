package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Constant_selectContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Constant_selectContextExt extends AbstractBaseExt {

	public Constant_selectContextExt(Constant_selectContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Constant_selectContext getContext() {
		return (Constant_selectContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).constant_select());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Constant_selectContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Constant_selectContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}