package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Trans_range_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Trans_range_listContextExt extends AbstractBaseExt {

	public Trans_range_listContextExt(Trans_range_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Trans_range_listContext getContext() {
		return (Trans_range_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).trans_range_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Trans_range_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Trans_range_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}