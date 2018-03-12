package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Remain_active_flagContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Remain_active_flagContextExt extends AbstractBaseExt {

	public Remain_active_flagContextExt(Remain_active_flagContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Remain_active_flagContext getContext() {
		return (Remain_active_flagContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).remain_active_flag());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Remain_active_flagContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Remain_active_flagContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}