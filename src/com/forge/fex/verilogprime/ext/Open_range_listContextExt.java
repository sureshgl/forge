package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Open_range_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Open_range_listContextExt extends AbstractBaseExt {

	public Open_range_listContextExt(Open_range_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Open_range_listContext getContext() {
		return (Open_range_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).open_range_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Open_range_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Open_range_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}