package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Join_namestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Join_namestrContextExt extends AbstractBaseExt {

	public Join_namestrContextExt(Join_namestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Join_namestrContext getContext() {
		return (Join_namestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).join_namestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Join_namestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Join_namestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}