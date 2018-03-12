package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Join_anystrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Join_anystrContextExt extends AbstractBaseExt {

	public Join_anystrContextExt(Join_anystrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Join_anystrContext getContext() {
		return (Join_anystrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).join_anystr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Join_anystrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Join_anystrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}