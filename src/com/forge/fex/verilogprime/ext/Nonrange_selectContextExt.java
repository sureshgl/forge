package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Nonrange_selectContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Nonrange_selectContextExt extends AbstractBaseExt {

	public Nonrange_selectContextExt(Nonrange_selectContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Nonrange_selectContext getContext() {
		return (Nonrange_selectContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nonrange_select());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Nonrange_selectContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Nonrange_selectContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}