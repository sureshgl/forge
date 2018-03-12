package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Default_skewContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Default_skewContextExt extends AbstractBaseExt {

	public Default_skewContextExt(Default_skewContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Default_skewContext getContext() {
		return (Default_skewContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).default_skew());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Default_skewContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Default_skewContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}