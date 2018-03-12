package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Rs_production_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Rs_production_listContextExt extends AbstractBaseExt {

	public Rs_production_listContextExt(Rs_production_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Rs_production_listContext getContext() {
		return (Rs_production_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rs_production_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Rs_production_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Rs_production_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}