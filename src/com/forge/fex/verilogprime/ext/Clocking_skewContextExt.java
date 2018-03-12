package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_skewContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_skewContextExt extends AbstractBaseExt {

	public Clocking_skewContextExt(Clocking_skewContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_skewContext getContext() {
		return (Clocking_skewContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_skew());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_skewContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Clocking_skewContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}