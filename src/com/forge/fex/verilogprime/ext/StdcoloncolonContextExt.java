package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StdcoloncolonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StdcoloncolonContextExt extends AbstractBaseExt {

	public StdcoloncolonContextExt(StdcoloncolonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StdcoloncolonContext getContext() {
		return (StdcoloncolonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).stdcoloncolon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StdcoloncolonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StdcoloncolonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}